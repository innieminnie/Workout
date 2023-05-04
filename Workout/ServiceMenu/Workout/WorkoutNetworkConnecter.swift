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
  func childChanged(_ workoutId: String, _ workout: Workout)
}

class WorkoutNetworkConnecter: NetworkAccessible {
  private lazy var workoutReference: DatabaseReference = {
    return ref.child(self.workoutLocation)
  }()
  
  weak var workoutDelegate: WorkoutDelegate?
  
  init() {
    self.setChildAddListener()
    self.setChildChangeListener()
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
  
  private func setChildChangeListener() {
    workoutReference.observe(.childChanged) { [weak self] snapshot in
      guard snapshot.exists() else { return }
      
      let jsonKey = snapshot.key
      guard let self = self, let jsonValue = snapshot.value else { return }
      
      do {
        let data = try JSONSerialization.data(withJSONObject: jsonValue)
        let workout = try self.decoder.decode(Workout.self, from: data)
        workout.configureId(with: jsonKey)
        
        self.workoutDelegate?.childChanged(snapshot.key, workout)
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
  
  func updateWorkoutData(workout: Workout) {
    guard let id = workout.id else { return }
    
    do {
      let data = try self.encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      let childUpdates = [workoutCodeLocation(id): json]
      self.ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func updateWorkoutRegistrationDate(code: String, dateSet: Set<DateInformation>) {
    do {
      let data = try self.encoder.encode(Array(dateSet))
      let json = try JSONSerialization.jsonObject(with: data)
      let childUpdates = [workoutRegisteredDateLocation(code): json]
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
