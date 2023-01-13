//
//  WorkoutStatus.swift
//  Workout
//
//  Created by 강인희 on 2022/07/21.
//

import Foundation

enum WorkoutStatus: Codable {
  case done
  case doing
  
  var buttonTitle: String {
    switch self {
    case .doing:
      return "운동완료"
    case .done:
      return "기록수정"
    }
  }
}
extension WorkoutStatus: RawRepresentable {
  typealias RawValue = Bool
  
  init(rawValue: Bool) {
    if rawValue {
      self = .done
    } else {
      self = .doing
    }
  }
  
  var rawValue: Bool {
    switch self {
    case .done:
      return true
    case .doing:
      return false
    }
  }
}
