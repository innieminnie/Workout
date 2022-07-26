//
//  PlannedWorkout.swift
//  Workout
//
//  Created by 강인희 on 2022/07/13.
//

import Foundation

class PlannedWorkout: Encodable {
  let workout: Workout
  var isDone: WorkoutStatus
  var sets: [UInt : SetConfiguration]
  var totalSum: Float {
    return sets.values.reduce(0){ return $0 + $1.weightTimesCount()}
  }
  private var compiledSets: [[UInt : SetConfiguration]] {
    sets.map { (key: UInt, value: SetConfiguration) in
      [key : value]
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case workoutName
    case isDone
    case setsCompilation
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
extension PlannedWorkout {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(workout.name, forKey: .workoutName)
    try container.encode(isDone, forKey: .isDone)
    try container.encode(compiledSets, forKey: .setsCompilation)
  }
}
