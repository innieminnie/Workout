//
//  CustomCalendar.swift
//  Workout
//
//  Created by 강인희 on 2022/02/14.
//

import Foundation

struct CustomCalendar {
  private var currentYear: Int
  private var currentMonth: Int
  
  private func getCurrentFirstWeekday() -> Int {
    let day = ("\(currentYear) - \(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
    return day
  }
}

extension String {
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  var date: Date? {
    return String.dateFormatter.date(from: self)
  }
}
extension Date {
  var weekday: Int {
    get {
      Calendar.current.component(.weekday, from: self)
    }
  }
  
  var firstDayOfTheMonth: Date {
    get {
      Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
  }
}
