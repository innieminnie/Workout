//
//  WorkoutStatus.swift
//  Workout
//
//  Created by 강인희 on 2022/07/21.
//

import Foundation

enum WorkoutStatus {
  case doing
  case done
  
  var buttonTitle: String {
    switch self {
    case .doing:
      return "운동완료"
    case .done:
      return "기록수정"
    }
  }
}
