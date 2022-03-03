//
//  MonthInformation.swift
//  Workout
//
//  Created by 강인희 on 2022/03/03.
//

import Foundation

struct MonthInformation {
  static func weekDayIndexOfFirstDay(year: Int, month: Int) -> Int {
    guard let formattedFirstDate = "\(year)-\(month)-01".date else {
      return -1
    }
    
    let firstDateComponents = Calendar.current.dateComponents([.year, .month], from: formattedFirstDate)
    
    guard let firstDate = Calendar.current.date(from: firstDateComponents) else {
      return -1
    }
  
    return Calendar.current.component(.weekday, from: firstDate) - 1
  }
  
  static func numberOfDays(year: Int, month: Int) -> Int {
    let dateComponents = DateComponents(year: year, month: month)
    
    guard let date = Calendar.current.date(from: dateComponents) else {
      return -1
    }
    
    guard let monthRange = Calendar.current.range(of: .day, in: .month, for: date) else {
      return 0
    }
    
    return monthRange.count
  }
  
  static func lastMonthTracker(from year: Int, month: Int) -> Int {
    var lastMonth = (month + 12) % 13
    var yearOfLastMonth = year

    if lastMonth == 0 {
      lastMonth = 12
      yearOfLastMonth = year - 1
    }
   
    return numberOfDays(year: yearOfLastMonth, month: lastMonth)
  }
}
