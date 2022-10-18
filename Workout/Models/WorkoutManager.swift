//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation

class WorkoutManager {
  static let shared = WorkoutManager()
  
  private var workoutList: [Workout] = [
    Workout("스쿼트", BodySection.hip),
    Workout("런지", BodySection.hip),
    Workout("데드리프트", BodySection.back),
    Workout("벤치프레스", BodySection.chest),
  ]
  
  private init() { }
  
  func numberOfWorkoutList() -> Int {
    return workoutList.count
  }
  
  func register(workout: Workout) {
    self.workoutList.append(workout)
    workoutList.sort { workout1, workout2 in
      return workout1.name < workout2.name
    }
  }
  
  func workout(at index: Int) -> Workout {
    return workoutList[index]
  }
}

let workoutManager = WorkoutManager.shared
