//
//  WorkOut.swift
//  Workout
//
//  Created by 강인희 on 2021/12/06.
//

import Foundation

class Workout: Codable {
  var name: String
  private var bodySection: BodySection?
  
  init(_ name: String, _ bodySection: BodySection) {
    self.name = name
    self.bodySection = bodySection
  }
  
  func searchBodySection() {
    self.bodySection = BodySection.leg //temporary
  }
}
