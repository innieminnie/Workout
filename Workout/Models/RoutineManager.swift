//
//  RoutineManager.swift
//  Workout
//
//  Created by 강인희 on 2022/06/21.
//

import Foundation

class RoutineManager {
  static let shared = RoutineManager()
  private var workoutPlanner: [DateInformation : [PlannedWorkout]]
  
  private init() {
    workoutPlanner = [:]
  }
  
  func plan(of dateInformation: DateInformation) -> [PlannedWorkout] {
    return workoutPlanner[dateInformation] ?? []
  }

  func addPlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    workoutPlanner[dateInformation] = workouts
  }
  
  func updatePlan(of date: DateInformation, with workouts: [PlannedWorkout]) {
    guard workoutPlanner[date] != nil else {
      return
    }
    
    workoutPlanner[date] = workouts
  }
}

let routineManager = RoutineManager.shared
