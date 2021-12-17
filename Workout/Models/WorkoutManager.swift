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
  
  func numberOfWorkoutList() -> Int {
    return workoutList.count
  }
  
  func register(workout: Workout) {
    self.workoutList.append(workout)
    
  }
  
  func workout(at index: Int) -> Workout {
    return workoutList[index]
  }
}

let workoutManager = WorkoutManager.shared
