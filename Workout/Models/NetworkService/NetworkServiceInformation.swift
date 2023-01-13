//
//  NetworkServiceInformation.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/21.
//

import Foundation
import FirebaseDatabase

struct NetworkServiceInformation {
  static let encoder = JSONEncoder()
  static let decoder = JSONDecoder()
  static let ref: DatabaseReference! = Database.database().reference()
  static var uid: String {
    if let currentUser = currentUser { return currentUser.uid }
    else { return AuthenticationManager.signedUpUser }
  }
}

