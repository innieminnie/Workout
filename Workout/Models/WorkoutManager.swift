//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation

class WorkoutManager {
  static let shared = WorkoutManager()
  
  private var workoutList = [Workout]()
  
  private init() { }
  
  func register(workout: Workout) {
    self.workoutList.append(workout)
  }
}

let workoutManager = WorkoutManager.shared
