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
  
  private var workoutList: [Workout] = [
    Workout("스쿼트", BodySection.hip),
    Workout("런지", BodySection.hip),
    Workout("데드리프트", BodySection.back),
    Workout("벤치프레스", BodySection.chest),
  ]
  
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
          let decodedWorkout = try self.decoder.decode([String : Workout].self, from: data)
          
          let decodedWorkoutList = decodedWorkout.map { (key: String, value: Workout) -> Workout in
            value.configureId(with: key)
            return value
          }.sorted { workout1, workout2 in
            workout1.id < workout2.id
          }
          
          self.workoutList = decodedWorkoutList
          NotificationCenter.default.post(name: Notification.Name("ReadWorkoutData"), object: nil, userInfo: ["workoutList": decodedWorkoutList])
          
        } catch {
          print(error)
        }
      } else {
        NotificationCenter.default.post(name: Notification.Name("ReadWorkoutData"), object: nil, userInfo: ["workoutList": []])
      }
    }
  }
  
  func numberOfWorkoutList() -> Int {
    return workoutList.count
  }
  
  func register(workout: Workout) {
    self.workoutList.append(workout)
    workoutList.sort { workout1, workout2 in
      return workout1.name < workout2.name
    }
    
    let itemRef = ref.child("workout")
    guard let key = itemRef.childByAutoId().key else { return }
    workout.configureId(with: key)
    
    do {
      let data = try encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/workout/\(key)/": json]
      self.ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func workout(at index: Int) -> Workout {
    return workoutList[index]
  }
}

let workoutManager = WorkoutManager.shared
