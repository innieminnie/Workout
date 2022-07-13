//
//  PlannedWorkout.swift
//  Workout
//
//  Created by 강인희 on 2022/07/13.
//

import Foundation

class PlannedWorkout {
  let workout: Workout
  var sets: [Int : SetConfiguration]
  
  init(_ workout: Workout) {
    self.workout = workout
    self.sets = [:]
  }
  
  func updateWeight(of index: Int, to newValue: Int) {
    guard let updatingSet = self.sets[index] else {
      sets[index] = SetConfiguration(weight: newValue)
      return
    }
    
    updatingSet.weight = newValue
  }
  
  func updateCount(of index: Int, to newValue: Int) {
    guard let updatingSet = self.sets[index] else {
      sets[index] = SetConfiguration(count: newValue)
      return
    }
    
    updatingSet.count = newValue
  }
}
