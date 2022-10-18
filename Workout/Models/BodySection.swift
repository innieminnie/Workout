//
//  BodySection.swift
//  Workout
//
//  Created by 강인희 on 2022/10/18.
//

import Foundation

enum BodySection: CustomStringConvertible, Codable {
  case chest
  case abs
  case shoulder
  case biceps
  case triceps
  case back
  case hip
  case leg

  var description: String {
    switch self {
    case .chest: return "가슴"
    case .abs: return "복근"
    case .shoulder: return "어깨"
    case .biceps: return "이두"
    case.triceps: return "삼두"
    case.back: return "등"
    case.hip: return "엉덩이"
    case.leg: return "다리"
    }
  }
}
