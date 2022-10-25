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
  private var bodySection: BodySection
  
  enum CodingKeys: String, CodingKey {
    case name
    case bodySection
  }
  
  init(_ name: String, _ bodySection: BodySection) {
    self.name = name
    self.bodySection = bodySection
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    bodySection = try values.decode(BodySection.self, forKey: .bodySection)
  }
  
  func configureId(with id: String) {
    guard self.id == nil else { return }
    self.id = id
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
  }
}
