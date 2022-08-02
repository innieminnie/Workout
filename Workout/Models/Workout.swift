//
//  WorkOut.swift
//  Workout
//
//  Created by 강인희 on 2021/12/06.
//

import Foundation

struct Workout: Codable {
  let name: String
  
  init(_ name: String) {
    self.name = name
  }
}
