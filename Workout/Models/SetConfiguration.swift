//
//  SetConfiguration.swift
//  Workout
//
//  Created by 강인희 on 2022/07/12.
//

import Foundation

class SetConfiguration {
  var isDone: Bool
  var weight: Int
  var count: Int
  
  init() {
    self.isDone = false
    self.weight = 0
    self.count = 0
  }
  
  init(weight w: Int) {
    self.isDone = false
    self.weight = w
    self.count = 0
  }
  
  init(count c: Int) {
    self.isDone = false
    self.weight = 0
    self.count = c
  }
}
