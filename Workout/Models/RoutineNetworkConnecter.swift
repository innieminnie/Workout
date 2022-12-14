//
//  RoutineNetworkConnecter.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/15.
//

import Foundation
import FirebaseDatabase

struct RoutineNetworkConnecter {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let ref: DatabaseReference! = Database.database().reference()
  private var uid: String {
    if let currentUser = currentUser { return currentUser.uid }
    else { return AuthenticationManager.signedUpUser }
  }
  
  init() { }
  
  func routineReference(dateInformation dateInfo: DateInformation) -> DatabaseReference {
    return self.ref.child("users/\(self.uid)/routine/\(dateInfo)")
  }
  
  func fetchRoutineData(dateInformation: DateInformation, completion: @escaping([String : PlannedWorkout]?, Error?) -> Void) {
    let itemRef = self.routineReference(dateInformation: dateInformation)
    itemRef.getData { error, snapshot in
      if let error = error {
        completion(nil, error)
      } else if snapshot.exists() {
        guard let jsonValue = snapshot.value as? [String: Any] else {
          return
        }
        
        do {
          let data = try JSONSerialization.data(withJSONObject: jsonValue)
          let decodedRoutine = try self.decoder.decode([String : PlannedWorkout].self, from: data)
          completion(decodedRoutine, nil)
        } catch {
          completion(nil, error)
        }
      } else {
        completion([:], nil)
      }
    }
  }
  
  func addRoutineData(workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    let itemRef = self.routineReference(dateInformation: dateInformation)
    
    for workout in workouts {
      do {
        guard let key = itemRef.childByAutoId().key else { return }
        
        workout.id = key
        let data = try encoder.encode(workout)
        let json = try JSONSerialization.jsonObject(with: data)
        
        let childUpdates = ["/users/\(self.uid)/routine/\(dateInformation)/\(key)/": json]
        self.ref.updateChildValues(childUpdates)
      } catch {
        print(error)
      }
    }
  }
  
  func updateRoutineData(workout: PlannedWorkout, on dateInformation: DateInformation) {
    do {
      guard let id = workout.id else { return }
      let data = try encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      
      let childUpdates = ["/users/\(self.uid)/routine/\(dateInformation)/\(id)/": json]
      ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func removeRoutineData(id: String, on dateInformation: DateInformation) {
    let itemRef = self.routineReference(dateInformation: dateInformation)
    itemRef.child("/\(id)").removeValue()
  }
}
