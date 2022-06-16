//
//  MonthInformation.swift
//  Workout
//
//  Created by 강인희 on 2022/03/03.
//

import Foundation

struct MonthlyInformation {
  private var year: Int
  private var month: Int
  var currentDate: String {
    return "\(self.year)년 \(self.month)월"
  }
  var startDate: Date {
    "\(self.year)-\(self.month)-01".date!
  }
  var weekDayIndexOfFirstDay: Int {
    return Calendar.current.component(.weekday, from: self.startDate) - 1
  }
  var numberOfDays: Int {
    let dateComponents = DateComponents(year: self.year, month: self.month)
    
    guard let date = Calendar.current.date(from: dateComponents) else {
      return -1
    }
    
    guard let monthRange = Calendar.current.range(of: .day, in: .month, for: date) else {
      return 0
    }
    
    return monthRange.count
  }

  init(_ year: Int, _ month: Int) {
    self.year = year
    self.month = month
  }

  func currentMonthInformation() -> (Int, Int) {
    return (self.year, self.month)
  }
  
  func lastMonthInformation() -> (Int, Int) {
    let dateInLastMonth = Calendar.current.date(byAdding: .month, value: -1,  to: self.startDate)
    let yearOfLastMonth = Calendar.current.component(.year, from: dateInLastMonth!)
    let lastMonth = Calendar.current.component(.month, from: dateInLastMonth!)
    
    return (yearOfLastMonth, lastMonth)
  }
  
  func nextMonthInformation() -> (Int, Int) {
    let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.startDate)
    let yearOfNextMonth = Calendar.current.component(.year, from: dateInNextMonth!)
    let nextMonth = Calendar.current.component(.month, from: dateInNextMonth!)
    
    return (yearOfNextMonth, nextMonth)
  }
  
  mutating func changeToNextMonth() {
    let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1,  to: self.startDate)
    self.year = Calendar.current.component(.year, from: dateInNextMonth!)
    self.month = Calendar.current.component(.month, from: dateInNextMonth!)
  }
  
  mutating func changeToLastMonth() {
    let dateInLastMonth = Calendar.current.date(byAdding: .month, value: -1,  to: self.startDate)
    self.year = Calendar.current.component(.year, from: dateInLastMonth!)
    self.month = Calendar.current.component(.month, from: dateInLastMonth!)
  }
  
  func numberOfDaysToDisplay() -> Int {
    let daysOfLastMonthToDisplay = self.weekDayIndexOfFirstDay
    
    let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1,  to: self.startDate)
    let weekDayOfFirstDayOfNextMonth = Calendar.current.component(.weekday, from: dateInNextMonth!)
    
    guard weekDayOfFirstDayOfNextMonth > 1 else {
      return daysOfLastMonthToDisplay + self.numberOfDays
    }
    
    return daysOfLastMonthToDisplay + self.numberOfDays + (weekDayOfFirstDayOfNextMonth...7).count
  }
}
