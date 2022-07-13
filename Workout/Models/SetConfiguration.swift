//
//  SetConfiguration.swift
//  Workout
//
//  Created by 강인희 on 2022/07/12.
//

import Foundation

class SetConfiguration {
  var weight: Int
  var count: Int
  
  init() {
    self.weight = 0
    self.count = 0
  }
  
  init(weight w: Int) {
    self.weight = w
    self.count = 0
  }
  
  init(count c: Int) {
    self.weight = 0
    self.count = c
  }
  
  func updateWeight(with w: Int) {
    self.weight = w
  }
  
  func updateCount(with c: Int) {
    self.count = c
  }
  
  func weightTimesCount() -> Int {
    return self.weight * self.count
  }
}
