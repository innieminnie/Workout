//
//  PlannedWorkout.swift
//  Workout
//
//  Created by 강인희 on 2022/07/13.
//

import Foundation

class PlannedWorkout {
  let workout: Workout
  var isDone: WorkoutStatus
  var sets: [UInt : SetConfiguration]
  var totalSum: Float {
    return sets.values.reduce(0){ return $0 + $1.weightTimesCount()}
  }
  
  init(_ workout: Workout) {
    self.workout = workout
    self.isDone = .doing
    self.sets = [:]
  }
  
  func addNewSet(of index: UInt) {
    sets[index] = SetConfiguration()
  }
  
  func updateWeight(of index: UInt, to newValue: Float) {
    guard let updatingSet = self.sets[index] else {
      sets[index] = SetConfiguration(weight: newValue)
      return
    }
    
    updatingSet.updateWeight(with: newValue)
  }
  
  func updateCount(of index: UInt, to newValue: UInt) {
    guard let updatingSet = self.sets[index] else {
      sets[index] = SetConfiguration(count: newValue)
      return
    }
    
    updatingSet.updateCount(with: newValue)
  }
  
  func removeSet(of index: UInt) {
    sets.removeValue(forKey: index)
  }
}
