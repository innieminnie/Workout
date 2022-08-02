//
//  PlannedWorkout.swift
//  Workout
//
//  Created by 강인희 on 2022/07/13.
//

import Foundation

class PlannedWorkout: Identifiable, Codable {
  var id: String?
  var sequenceNumber: UInt
  let workout: Workout
  var isDone: WorkoutStatus
  var sets: [SetConfiguration]
  var totalSum: Float {
    return sets.reduce(0){ return $0 + $1.weightTimesCount()}
  }
  
  enum CodingKeys: String, CodingKey {
    case sequenceNumber
    case workout
    case isDone
    case sets
  }
  
  init(_ workout: Workout, _ sequenceNumber: UInt ) {
    self.sequenceNumber = sequenceNumber
    self.workout = workout
    self.isDone = .doing
    self.sets = []
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    sequenceNumber = try values.decode(UInt.self, forKey: .sequenceNumber)
    workout = try values.decode(Workout.self, forKey: .workout)
    let status = try values.decode(Int.self, forKey: .isDone)
    isDone = status == 0 ? .doing : .done
    sets = try values.decode([SetConfiguration].self, forKey: .sets)
  }
  
  func addNewSet() {
    sets.append(SetConfiguration())
  }
  
  func updateWeight(of index: Int, to newValue: Float) {
    guard sets.count > index else {
      return
    }
    
    sets[index].updateWeight(with: newValue)
  }
  
  func updateCount(of index: Int, to newValue: UInt) {
    guard sets.count > index else {
      return
    }
    
    sets[index].updateCount(with: newValue)
  }
  
  func removeSet(of index: Int) {
    sets.remove(at: index)
  }
}
extension PlannedWorkout {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sequenceNumber, forKey: .sequenceNumber)
    try container.encode(workout, forKey: .workout)
    try container.encode(isDone, forKey: .isDone)
    try container.encode(sets, forKey: .sets)
  }
}
