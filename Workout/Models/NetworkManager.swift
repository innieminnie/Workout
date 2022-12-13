//
//  NetworkManager.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/13.
//

import Foundation
import FirebaseDatabase

class NetworkManager {
  static let shared = NetworkManager()
  private let encoder = JSONEncoder()
  static let decoder = JSONDecoder()
  private let ref: DatabaseReference! = Database.database().reference()
  private var uid: String {
    if let currentUser = currentUser { return currentUser.uid }
    else { return AuthenticationManager.signedUpUser }
  }
  
  private init() { }
  
  func workoutReference() -> DatabaseReference {
    return ref.child("users/\(self.uid)/workout")
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
}

let networkManager = NetworkManager.shared
