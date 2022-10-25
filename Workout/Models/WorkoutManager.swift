//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation
import Firebase

class WorkoutManager {
  static let shared = WorkoutManager()
  private let ref: DatabaseReference! = Database.database().reference()
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  private var workoutList = [Workout]()
  private var workoutCodeDictionary = [String: Workout]()
  
  private init() { }
  
  func readWorkoutData() {
    let itemRef = ref.child("workout")
    
    itemRef.getData { error, snapshot in
      if let error = error {
        print(error)
      } else if snapshot.exists() {
        guard let jsonValue = snapshot.value as? [String: Any] else {
          return
        }
        
        do {
          let data = try JSONSerialization.data(withJSONObject: jsonValue)
          self.workoutCodeDictionary = try self.decoder.decode([String : Workout].self, from: data)
          self.workoutList = self.workoutCodeDictionary.map { (key: String, value: Workout) -> Workout in
            value.configureId(with: key)
            return value
          }.sorted { workout1, workout2 in
            workout1.id < workout2.id
          }
        } catch {
          print(error)
        }
      }
    }
  }
  
  func numberOfWorkoutList() -> Int {
    return workoutList.count
  }
  
  func register(workout: Workout) {
    self.workoutList.append(workout)
    workoutList.sort { workout1, workout2 in
      return workout1.displayName() < workout2.displayName()
    }
    
    let itemRef = ref.child("workout")
    guard let key = itemRef.childByAutoId().key else { return }
    workout.configureId(with: key)
    
    do {
      let data = try encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/workout/\(key)/": json]
      self.ref.updateChildValues(childUpdates)
      self.workoutCodeDictionary[key] = workout
    } catch {
      print(error)
    }
  }
  
  func workout(at index: Int) -> Workout {
    return workoutList[index]
  }
  
  func workoutByCode(_ code: String) -> Workout? {
    return workoutCodeDictionary[code]
  }
  
  func removeWorkout(at index: Int) {
    let removingWorkout = workoutList[index]
    workoutList.remove(at: index)
    
    if let removingCode = removingWorkout.id {
      workoutCodeDictionary[removingCode] = nil
      
      let itemRef = ref.child("workout")
      itemRef.child("/\(removingCode)").removeValue()
    }
  }
  
  func updateWorkout(at index: Int, name: String, bodySection: BodySection) {
    let updatingWorkout = workoutList[index]
    guard let code = updatingWorkout.id else { return }
    updatingWorkout.update(name, bodySection)
  }
}

let workoutManager = WorkoutManager.shared
