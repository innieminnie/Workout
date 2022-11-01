//
//  SetConfiguration.swift
//  Workout
//
//  Created by 강인희 on 2022/07/12.
//

import Foundation

struct SetConfiguration: Codable {
  private var weight: Float
  private var count: UInt
  
  var displayWeight: Float {
    return self.weight
  }
  
  var displayCount: UInt {
    return self.count
  }
  
  enum CodingKeys: String, CodingKey {
    case weight
    case count
  }
  
  init() {
    self.weight = 0
    self.count = 0
  }
  
  mutating func updateWeight(with w: Float) {
    self.weight = w
  }
  
  mutating func updateCount(with c: UInt) {
    self.count = c
  }
  
  func weightTimesCount() -> Float {
    return self.weight * Float(self.count)
  }
}
