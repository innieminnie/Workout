//
//  RoutineManager.swift
//  Workout
//
//  Created by 강인희 on 2022/06/21.
//

import Foundation

class RoutineManager {
  static let shared = RoutineManager()
  
  private let networkConnecter = RoutineNetworkConnecter()
  private var workoutPlanner: [DateInformation : [PlannedWorkout]]
  private init() {
    workoutPlanner = [:]
  }
  
  func readRoutineData(from dateInformation: DateInformation) {
    networkConnecter.fetchRoutineData(dateInformation: dateInformation) { decodedRoutine, error in
      if let error = error {
        NotificationCenter.default.post(name: Notification.Name("ReadRoutineData"), object: nil, userInfo: ["error": error])
        return
      }
      
      if let decodedRoutine = decodedRoutine {
        let dailyRoutine = decodedRoutine.map { (key: String, value: PlannedWorkout) -> PlannedWorkout in
          value.setId(with: key)
          return value
        }.sorted { plannedWorkout1, plannedWorkout2 in
          plannedWorkout1.sequenceNumber < plannedWorkout2.sequenceNumber
        }
        
        self.workoutPlanner[dateInformation] = dailyRoutine
        
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: Notification.Name("ReadRoutineData"), object: nil, userInfo: ["dailyRoutine": dailyRoutine, "date": dateInformation])
        }
      }
      
      
    }
  }
  
  func plan(of dateInformation: DateInformation) -> [PlannedWorkout] {
    return workoutPlanner[dateInformation] ?? []
  }
  
  func addPlan(with workouts: [PlannedWorkout], on dateInformation: DateInformation) {
    workoutPlanner[dateInformation] =  plan(of: dateInformation) + workouts
    networkConnecter.addRoutineData(workouts: workouts, on: dateInformation)
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
      networkConnecter.updateRoutineData(workout: workout, on: dateInformation)
    }
  }
  
  func removePlannedWorkout(at removingPosition: Int, on dateInformation: DateInformation) {
    var reorderingPlan = self.plan(of: dateInformation)
    let removingWorkout = reorderingPlan[removingPosition]
    reorderingPlan.remove(at: removingPosition)
    workoutPlanner[dateInformation] = reorderingPlan
    
    guard let id = removingWorkout.id else { return }
    networkConnecter.removeRoutineData(id: id, on: dateInformation)
    let workoutCode = removingWorkout.workoutCode
    if let workout = workoutManager.workoutByCode(workoutCode) {
      workout.removeRegisteredDate(on: dateInformation)
    }
   
    self.updatePlan(with: reorderingPlan, on: dateInformation)
  }
  
  func removeRegisteredWorkout(code workoutCode: String, on date: DateInformation) {
    var reorderingPlan = self.plan(of: date)
    var removingPosition = [Int]()
    
    for  index in (0..<reorderingPlan.count).reversed() {
      if reorderingPlan[index].workoutCode == workoutCode { removingPosition.append(index) }
    }
    
    let itemRef = networkConnecter.routineReference(dateInformation: date)
    
    for removingIndex in removingPosition {
      guard let removingID = reorderingPlan[removingIndex].id else { continue }
      itemRef.child("/\(removingID)").removeValue()
      reorderingPlan.remove(at: removingIndex)
    }
    
    workoutPlanner[date] = reorderingPlan
    self.updatePlan(with: reorderingPlan, on: date)
  }
}

let routineManager = RoutineManager.shared
