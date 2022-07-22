//
//  SetConfiguration.swift
//  Workout
//
//  Created by 강인희 on 2022/07/12.
//

import Foundation

class SetConfiguration {
  var weight: Float
  var count: UInt
  
  init() {
    self.weight = 0
    self.count = 0
  }
  
  init(weight w: Float) {
    self.weight = w
    self.count = 0
  }
  
  init(count c: UInt) {
    self.weight = 0
    self.count = c
  }
  
  func updateWeight(with w: Float) {
    self.weight = w
  }
  
  func updateCount(with c: UInt) {
    self.count = c
  }
  
  func weightTimesCount() -> Float {
    return self.weight * Float(self.count)
  }
}
