//
//  WorkoutNetworkConnecter.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/15.
//

import Foundation
import FirebaseDatabase

struct WorkoutNetworkConnecter: NetworkAccessible {
  init() { }
  
  private func workoutReference() -> DatabaseReference {
    return ref.child("users/\(self.uid)/workout")
  }
  
  func fetchWorkoutData(completion: @escaping ([String: Workout]?, Error?) -> Void) {
    let itemRef = self.workoutReference()
    itemRef.getData { error, snapshot in
      if let error = error {
        completion(nil, error)
      } else if let snapshot = snapshot, snapshot.exists() {
        guard let jsonValue = snapshot.value as? [String: Any] else {
          return
        }
        
        do {
          let data = try JSONSerialization.data(withJSONObject: jsonValue)
          let workoutDictionary = try self.decoder.decode([String : Workout].self, from: data)
          completion(workoutDictionary, nil)
        } catch {
          completion(nil, error)
        }
        
        completion(nil, error)
      }
    }
  }
  
  func createWorkoutId (workout: Workout, completion: @escaping (String) -> Void) {
    let itemRef = self.workoutReference()
    if let key = itemRef.childByAutoId().key {
     completion(key)
    }
  }
  
  func updateWorkoutData(workout: Workout, key: String) {
    do {
      let data = try self.encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      let childUpdates = ["/users/\(self.uid)/workout/\(key)/": json]
      self.ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func updateWorkoutRegistrationDate(code: String, date: Set<DateInformation>) {
    do {
      let data = try self.encoder.encode(Array(date))
      let json = try JSONSerialization.jsonObject(with: data)
      let childUpdates = ["/users/\(self.uid)/workout/\(code)/registeredDate": json]
      self.ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func removeWorkoutData(workout: Workout) {
    if let workoutCode = workout.id {
      let itemRef = self.workoutReference()
      itemRef.child("/\(workoutCode)").removeValue()
    }
  }
}
