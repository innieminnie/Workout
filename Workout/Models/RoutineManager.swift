//
//  RoutineManager.swift
//  Workout
//
//  Created by 강인희 on 2022/06/21.
//

import Foundation

class RoutineManager {
  static let shared = RoutineManager()
  private var dictionary: [DateInformation : [Workout]]
  
  private init() {
    dictionary = [:]
  }

  func plan(of dateInformation: DateInformation) -> [Workout] {
    return dictionary[dateInformation] ?? []
  }
}

let routineManager = RoutineManager.shared
