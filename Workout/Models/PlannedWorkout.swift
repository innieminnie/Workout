//
//  PlannedWorkout.swift
//  Workout
//
//  Created by 강인희 on 2022/07/13.
//

import Foundation

class PlannedWorkout: Identifiable, Codable {
  var id: String?
  let workoutCode: String
  var sequenceNumber: UInt
  var isDone: WorkoutStatus
  var sets: [SetConfiguration]
  var totalSum: Float {
    return sets.reduce(0){ return $0 + $1.weightTimesCount()}
  }
  
  enum CodingKeys: String, CodingKey {
    case workoutCode
    case sequenceNumber
    case isDone
    case sets
  }
  
  init(_ workout: Workout, _ sequenceNumber: UInt, _ planningDate: DateInformation ) {
    guard let workoutCode = workout.id else { fatalError() }
    self.workoutCode = workoutCode
    self.sequenceNumber = sequenceNumber
    self.isDone = .doing
    self.sets = []
    
    workout.addRegisteredDate(on: planningDate)
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    sequenceNumber = try values.decode(UInt.self, forKey: .sequenceNumber)
    workoutCode = try values.decode(String.self, forKey: .workoutCode)
    let statusRawValue = try values.decode(Bool.self, forKey: .isDone)
    isDone = WorkoutStatus(rawValue: statusRawValue)
    
    do {
      sets = try values.decode([SetConfiguration].self, forKey: .sets)
    } catch {
      sets = []
    }
  }
  
  func setId(with key: String) {
    self.id = key
  }
  
  func addNewSet(with setConfiguration: SetConfiguration) {
    sets.append(setConfiguration)
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
  
  func checkWorkoutName() -> String {
    guard let workout = workoutManager.workoutByCode(self.workoutCode) else { return "    " }
    return workout.displayName()
  }
  
  func checkWorkoutBodySection() -> String {
    guard let workout = workoutManager.workoutByCode(self.workoutCode) else { return "    " }
    return workout.bodySection.rawValue
  }
}
extension PlannedWorkout {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sequenceNumber, forKey: .sequenceNumber)
    try container.encode(workoutCode, forKey: .workoutCode)
    try container.encode(isDone.rawValue, forKey: .isDone)
    try container.encode(sets, forKey: .sets)
  }
}
