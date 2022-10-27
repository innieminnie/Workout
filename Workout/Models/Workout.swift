//
//  WorkOut.swift
//  Workout
//
//  Created by 강인희 on 2021/12/06.
//

import Foundation

class Workout: Identifiable, Codable {
  var id: String?
  private var name: String
  var bodySection: BodySection
  private var registeredDate: Set<DateInformation>
  
  enum CodingKeys: String, CodingKey {
    case name
    case bodySection
    case registeredDate
  }
  
  init(_ name: String, _ bodySection: BodySection) {
    self.name = name
    self.bodySection = bodySection
    self.registeredDate = []
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    bodySection = try values.decode(BodySection.self, forKey: .bodySection)
    
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
  }
  
  func addRegisteredDate(on dateInformation: DateInformation) {
    guard !registeredDate.contains(dateInformation) else { return }
    
    registeredDate.insert(dateInformation)
    if let id = id {
      workoutManager.updateWorkoutRegistration(id, registeredDate)
    }
  }
 
  func displayName() -> String {
    return self.name
  }
  
  func update(_ name: String, _ bodySection: BodySection) {
    self.name = name
    self.bodySection = bodySection
  }
}
extension Workout {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(bodySection, forKey: .bodySection)
    try container.encode(registeredDate, forKey: .registeredDate)
  }
}
