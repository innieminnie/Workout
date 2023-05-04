//
//  NetworkServiceInformation.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/21.
//

import Foundation
import FirebaseDatabase

protocol NetworkAccessible {
  var encoder: JSONEncoder { get }
  var decoder: JSONDecoder { get }
  var ref: DatabaseReference! { get }
  var uid: String { get }
}
extension NetworkAccessible {
  var encoder: JSONEncoder {
    return NetworkServiceInformation.encoder
  }
  var decoder: JSONDecoder {
    return NetworkServiceInformation.decoder
  }
  var ref: DatabaseReference! {
    return NetworkServiceInformation.ref
  }
  var uid: String {
    return NetworkServiceInformation.uid
  }
}
extension NetworkAccessible {
  var workoutLocation: String {
    return "/users/\(self.uid)/workout"
  }
  
  func workoutCodeLocation(_ id: String) -> String {
    return "\(workoutLocation)/\(id)"
  }
  
  func workoutRegisteredDateLocation(_ id: String) -> String {
    return "\(workoutCodeLocation(id))/registeredDate"
  }
}

struct NetworkServiceInformation {
  static let encoder = JSONEncoder()
  static let decoder = JSONDecoder()
  static let ref: DatabaseReference! = Database.database().reference()
  static var uid: String {
    if let currentUser = currentUser { return currentUser.uid }
    else { return AuthenticationManager.signedUpUser }
  }
}

