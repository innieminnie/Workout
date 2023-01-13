//
//  Weekday.swift
//  Workout
//
//  Created by 강인희 on 2022/06/24.
//

import Foundation

struct Weekday {
  static let daysInWeek = 7
  static let weekdaysName = ["월", "화", "수", "목", "금", "토", "일"]
  
  var weekDayIndex: Int
  
  init(_ weekdayIndex: Int) {
    self.weekDayIndex = weekdayIndex
  }
  
  func convertWeekdayIndexToMondayBased() -> Int {
    switch self.weekDayIndex {
    case 1:
      return 6
    case 2:
      return 0
    case 3:
      return 1
    case 4:
      return 2
    case 5:
      return 3
    case 6:
      return 4
    case 7:
      return 5
    default:
      break
    }
    
    return -1
  }
  
  func weekdayName() -> String {
    return Weekday.weekdaysName[self.convertWeekdayIndexToMondayBased()]
  }
}
