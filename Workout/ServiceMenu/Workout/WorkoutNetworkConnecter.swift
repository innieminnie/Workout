//
//  WorkoutNetworkConnecter.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/15.
//

import Foundation
import FirebaseDatabase

protocol WorkoutDelegate: AnyObject {
  func childAdded(_ workout: Workout)
  func childRemoved(_ workoutId: String)
}

class WorkoutNetworkConnecter: NetworkAccessible {
  private lazy var workoutReference: DatabaseReference = {
    return ref.child("users/\(self.uid)/workout")
  }()
  
  weak var workoutDelegate: WorkoutDelegate?
  
  init() {
    self.setChildAddListener()
    self.setChildRemoveListener()
  }
  
  private func setChildAddListener() {
    workoutReference.observe(.childAdded) { [weak self] snapshot in
      guard snapshot.exists() else { return }
      
      let jsonKey = snapshot.key
      guard let self = self, let jsonValue = snapshot.value else { return }
      
      do {
        let data = try JSONSerialization.data(withJSONObject: jsonValue)
        let workout = try self.decoder.decode(Workout.self, from: data)
        workout.configureId(with: jsonKey)
        
        self.workoutDelegate?.childAdded(workout)
      } catch {
        NotificationCenter.default.post(name: Notification.Name("ReadWorkoutData"), object: nil, userInfo: ["error" : error])
      }
    }
  }
  
  private func setChildRemoveListener() {
    workoutReference.observe(.childRemoved) { [weak self] snapshot in
      guard snapshot.exists() else { return }
      guard let self = self else { return }
      self.workoutDelegate?.childRemoved(snapshot.key)
    }
  }
  
  func createWorkoutId (workout: Workout, completion: @escaping (String) -> Void) {
    if let key = workoutReference.childByAutoId().key {
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
      workoutReference.child("/\(workoutCode)").removeValue()
    }
  }
}
