//
//  WorkOut.swift
//  Workout
//
//  Created by 강인희 on 2021/12/06.
//

import Foundation

enum WeightUnit: String, CaseIterable, Codable {
  case kg = "kg"
  case lb = "lb"
}

enum BodySection: String, CaseIterable, Codable {
  case chest = "가슴"
  case abs = "복근"
  case shoulder = "어깨"
  case biceps = "이두"
  case triceps = "삼두"
  case back = "등"
  case hip = "엉덩이"
  case leg = "다리"
}

class Workout: Identifiable, Codable {
  var id: String?
  private var name: String
  var bodySection: BodySection
  var weightUnit: WeightUnit
  private var registeredDate: Set<DateInformation>
  
  enum CodingKeys: String, CodingKey {
    case name
    case bodySection
    case weightUnit
    case registeredDate
  }
  
  init(_ name: String, _ bodySection: BodySection, _ weightUnit: WeightUnit) {
    self.name = name
    self.bodySection = bodySection
    self.weightUnit = weightUnit
    self.registeredDate = []
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    bodySection = try values.decode(BodySection.self, forKey: .bodySection)
    weightUnit = try values.decode(WeightUnit.self, forKey: .weightUnit)
    
    do {
      let arrayRegisteredDate =  try values.decode([DateInformation].self, forKey: .registeredDate)
      registeredDate = Set(arrayRegisteredDate)
    } catch {
      registeredDate = []
    }
  }
  
  func configureId(with id: String) {
    guard self.id == nil else { return }
    self.id = id
    
    fetchRegisteredRoutine()
  }
  
  func addRegisteredDate(on dateInformation: DateInformation) {
    guard !registeredDate.contains(dateInformation) else { return }
    
    registeredDate.insert(dateInformation)
    if let id = id {
      workoutManager.updateWorkoutRegistration(id, registeredDate)
    }
  }
  
  func removeRegisteredDate(on dateInformation: DateInformation) {
    registeredDate.remove(dateInformation)
    
    if let id = id {
      workoutManager.updateWorkoutRegistration(id, registeredDate)
    }
  }
 
  func displayName() -> String {
    return self.name
  }
  
  func update(_ name: String, _ bodySection: BodySection, _ weightUnit: WeightUnit) {
    self.name = name
    self.bodySection = bodySection
    self.weightUnit = weightUnit
  }
  
  func removeRegisteredRoutine() {
    guard let id = self.id else { return }
    
    for date in registeredDate {
      routineManager.removeRegisteredWorkout(code: id, on: date)
    }
  }
  
  private func fetchRegisteredRoutine() {
    for date in registeredDate {
      routineManager.readRoutineData(from: date)
    }
  }
}
extension Workout {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(bodySection, forKey: .bodySection)
    try container.encode(weightUnit, forKey: .weightUnit)
    try container.encode(registeredDate, forKey: .registeredDate)
  }
}
