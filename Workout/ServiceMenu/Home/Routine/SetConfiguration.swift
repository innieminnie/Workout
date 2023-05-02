//
//  SetConfiguration.swift
//  Workout
//
//  Created by 강인희 on 2022/07/12.
//

import Foundation

struct SetConfiguration: Codable {
  private var weight: Float?
  private var count: UInt?
  
  var displayWeight: Float? {
    return self.weight
  }
  
  var displayCount: UInt? {
    return self.count
  }
  
  enum CodingKeys: String, CodingKey {
    case weight
    case count
  }
  
  init() { }
  
  mutating func updateWeight(with w: Float) {
    self.weight = w
  }
  
  mutating func updateCount(with c: UInt) {
    self.count = c
  }
  
  func weightTimesCount() -> Float {
    guard let weight = self.weight, let count = self.count else { return 0.0 }
    return weight * Float(count)
  }
}
