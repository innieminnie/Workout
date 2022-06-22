//
//  RoutineManager.swift
//  Workout
//
//  Created by 강인희 on 2022/06/21.
//

import Foundation

class RoutineManager {
  static let shared = RoutineManager()
  private var workoutPlanner: [DateInformation : [Workout]]
  
  private init() {
    workoutPlanner = [:]
  }
  
  func plan(of dateInformation: DateInformation) -> [Workout] {
    return workoutPlanner[dateInformation] ?? []
  }

  func addPlan(with workouts: [Workout], on dateInformation: DateInformation) {
    workoutPlanner[dateInformation] = workouts
  }
  
  func updateRoutine(of date: DateInformation, with workouts: [Workout]) {
    guard workoutPlanner[date] != nil else {
      return
    }
    
    workoutPlanner[date] = workouts
  }
}

let routineManager = RoutineManager.shared
