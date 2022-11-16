//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation
import FirebaseDatabase

class WorkoutManager {
  static let shared = WorkoutManager()
  private let ref: DatabaseReference! = Database.database().reference()
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private var workoutCodeDictionary = [String: Workout]()
  private var uid: String = {
    if let currentUser = currentUser { return currentUser.uid }
    else { return HomeViewController.uid }
  }()
  
  private init() { }
  
  func readWorkoutData() {
    let itemRef = ref.child("users/\(self.uid)/workout")
    
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
          
          for element in self.workoutCodeDictionary {
            element.value.configureId(with: element.key)
          }
        } catch {
          print(error)
        }
      }
    }
  }
  
  func numberOfWorkoutList() -> Int {
    return workoutCodeDictionary.count
  }
  
  func register(workout: Workout) {
    let itemRef = ref.child("users/\(self.uid))/workout")
    
    guard let key = itemRef.childByAutoId().key else { return }
    workout.configureId(with: key)
    
    do {
      let data = try encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/users/\(self.uid)/workout/\(key)/": json]
      
      self.ref.updateChildValues(childUpdates)
      self.workoutCodeDictionary[key] = workout
    } catch {
      print(error)
    }
  }
  
  func workout(at indexPath: IndexPath) -> Workout {
    let section = BodySection.allCases[indexPath.section]
    let filteredWorkout = filteredWorkout(by: section)
    
    return filteredWorkout[indexPath.row]
  }
  
  func workoutByCode(_ code: String) -> Workout? {
    return workoutCodeDictionary[code]
  }
  
  func removeWorkout(_ workout: Workout) {
    if let removingCode = workout.id {
      workoutCodeDictionary[removingCode] = nil
      workout.removeRegisteredRoutine()
      
      let itemRef = ref.child("users/\(self.uid)/workout")
      
      itemRef.child("/\(removingCode)").removeValue()
    }
  }
  
  func updateWorkout(_ code: String, _ name: String, _ bodySection: BodySection) {
    guard let updatingWorkout = workoutCodeDictionary[code] else { return }
    updatingWorkout.update(name, bodySection)
    
    do {
      let data = try encoder.encode(updatingWorkout)
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/users/\(self.uid)/\(code)": json]
      
      ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func updateWorkoutRegistration(_ code: String, _ registeredDate: Set<DateInformation>) {
    do {
      let data = try encoder.encode(Array(registeredDate))
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/users/\(self.uid)/workout/\(code)/registeredDate": json]
      ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func checkNameValidation(_ previousName: String, _ name: String) -> Bool {
    let nameList = Set(self.workoutCodeDictionary.values.map { $0.displayName() }.filter{ $0 != previousName })
    return !nameList.contains(name)
  }
  
  func filteredWorkout(by bodySection: BodySection) -> [Workout] {
    let filteredList = workoutCodeDictionary.values.filter { workout in
      workout.bodySection == bodySection
    }

    return filteredList
  }
  
  func searchWorkouts(by text: String) -> [Workout] {
    let filteredList = workoutCodeDictionary.values.filter { workout in
      workout.displayName().localizedCaseInsensitiveContains(text)
    }
    
    return filteredList
  }
}

let workoutManager = WorkoutManager.shared
