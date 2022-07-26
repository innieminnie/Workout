//
//  RoutineManager.swift
//  Workout
//
//  Created by 강인희 on 2022/06/21.
//

import Foundation
import Firebase

class RoutineManager {
  static let shared = RoutineManager()
  private var workoutPlanner: [DateInformation : [PlannedWorkout]]
  private var ref: DatabaseReference!
  
  private init() {
    workoutPlanner = [:]
  }
  
  func plan(of dateInformation: DateInformation) -> [PlannedWorkout] {
    return workoutPlanner[dateInformation] ?? []
  }

  func addPlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    workoutPlanner[dateInformation] = workouts
    
    self.ref = Database.database().reference()
    let itemRef = self.ref.child("routine/\(dateInformation.currentDate)")

    var temp = [Any]()
    for workout in workouts {
      do {
        let data = try JSONEncoder().encode(workout)
        let json = try JSONSerialization.jsonObject(with: data)
        temp.append(json)
      } catch {
        print(error)
      }
    }
    
    itemRef.setValue(temp)
  }
  
  func updatePlan(of date: DateInformation, with workouts: [PlannedWorkout]) {
    guard workoutPlanner[date] != nil else {
      return
    }
    
    workoutPlanner[date] = workouts
  }
}

let routineManager = RoutineManager.shared
