//
//  WorkOut.swift
//  Workout
//
//  Created by 강인희 on 2021/12/06.
//

import Foundation

struct Workout {
  private let name: String
  private let measurement: Measurement
  
  init(_ name: String, _ measurement: Measurement) {
    self.name = name
    self.measurement = measurement
  }
}