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
  private var encoder = JSONEncoder()
  
  private init() {
    workoutPlanner = [:]
  }
  
  func plan(of dateInformation: DateInformation) -> [PlannedWorkout] {
    return workoutPlanner[dateInformation] ?? []
  }

  func addPlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    workoutPlanner[dateInformation] = workouts
    
    let itemRef = configureDatabaseReference(dateInformation: dateInformation)

    do {
      let data = try encoder.encode(workouts)
      let json = try JSONSerialization.jsonObject(with: data)
      itemRef.setValue(json)
    } catch {
      print(error)
    }
  }
  
  func updatePlan(of date: DateInformation, with workouts: [PlannedWorkout]) {
    guard workoutPlanner[date] != nil else {
      return
    }
    
    workoutPlanner[date] = workouts
  }
  
  private func configureDatabaseReference(dateInformation dateInfo: DateInformation) -> DatabaseReference {
    self.ref = Database.database().reference()
    return self.ref.child("routine/\(dateInfo.currentDate)")
  }
}

let routineManager = RoutineManager.shared
