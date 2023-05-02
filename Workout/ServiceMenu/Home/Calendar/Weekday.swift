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
  
  func mondayBasedIndex() -> Int {
    let changedIndex = self.weekDayIndex - 2
    return changedIndex >= 0 ? changedIndex : changedIndex + Weekday.daysInWeek
  }
  
  func weekdayName() -> String {
    return Weekday.weekdaysName[self.mondayBasedIndex()]
  }
}
