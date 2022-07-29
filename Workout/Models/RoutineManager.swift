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
  private let ref: DatabaseReference! = Database.database().reference()
  private var encoder = JSONEncoder()
  
  private init() {
    workoutPlanner = [:]
  }
  
  func plan(of dateInformation: DateInformation) -> [PlannedWorkout] {
    return workoutPlanner[dateInformation] ?? []
  }
  
  func addPlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    let itemRef = configureDatabaseReference(dateInformation: dateInformation)
    
    for workout in workouts {
      do {
        guard let key = itemRef.childByAutoId().key else { return }
        
        workout.id = key
        let data = try encoder.encode(workout)
        let json = try JSONSerialization.jsonObject(with: data)
        
        let childUpdates = ["/routine/\(dateInformation.currentDate)/\(key)/": json]
        self.ref.updateChildValues(childUpdates)
      } catch {
        print(error)
      }
    }
    
    workoutPlanner[dateInformation] =  plan(of: dateInformation) + workouts
  }
  
  func reorderPlan(on date: DateInformation, removeAt removingPosition: Int, insertAt insertingPosition: Int) {
    var reorderingPlan = self.plan(of: date)
    let reorderingWorkout = reorderingPlan[removingPosition]
    reorderingPlan.remove(at: removingPosition)
    reorderingPlan.insert(reorderingWorkout, at: insertingPosition)
    workoutPlanner[date] = reorderingPlan
    self.updatePlan(with: reorderingPlan, on: date)
  }
  
  func updatePlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    guard workoutPlanner[dateInformation] != nil else {
      return
    }
    
    for (idx, workout) in workouts.enumerated() {
      workout.sequenceNumber = UInt(idx)
      updateWorkout(workout: workout, on: dateInformation)
    }
  }
  
  func updateWorkout(workout: PlannedWorkout, on dateInformation: DateInformation) {
    do {
      guard let id = workout.id else { return }
      let data = try encoder.encode(workout)
      let json = try JSONSerialization.jsonObject(with: data)
      let childUpdates = ["/routine/\(dateInformation.currentDate)/\(id)": json]
      ref.updateChildValues(childUpdates)
    } catch {
      print(error)
    }
  }
  
  func removeWorkout(at removingPosition: Int, on dateInformation: DateInformation) {
    var reorderingPlan = self.plan(of: dateInformation)
    let removingWorkout = reorderingPlan[removingPosition]
    reorderingPlan.remove(at: removingPosition)
    workoutPlanner[dateInformation] = reorderingPlan
    
    guard let id = removingWorkout.id else { return }
    let itemRef = configureDatabaseReference(dateInformation: dateInformation)
    itemRef.child("/\(id)").removeValue()
    
    self.updatePlan(with: reorderingPlan, on: dateInformation)
  }
  
  private func configureDatabaseReference(dateInformation dateInfo: DateInformation) -> DatabaseReference {
    return self.ref.child("routine/\(dateInfo.currentDate)")
  }
}

let routineManager = RoutineManager.shared
