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
  private var startDate: Date {
    let currentMonthStartDateComponents = DateComponents(year: self.year, month: self.month, day: 1)
    let date = Calendar.current.date(from: currentMonthStartDateComponents)
    
    return date!
  }
  private var numberOfDaysInMonth: Int {
    let dateComponents = DateComponents(year: self.year, month: self.month)
    
    guard let date = Calendar.current.date(from: dateComponents),
          let interval = Calendar.current.dateInterval(of: .month, for: date),
          let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day else { return -1 }
  
    return days
  }
  private var weekDayIndexOfFirstDay: Int {
    return Weekday(Calendar.current.component(.weekday, from: self.startDate)).convertWeekdayIndexToMondayBased()
  }
  private var calendarDisplayingDateComponents: [(dateComponent: DateComponents, isCurrentMonth: Bool)] {
    return self.lastMonthDateComponents + self.currentMonthDateComponents + self.nextMonthDateComponents
  }
  private var lastMonthDateComponents: [(dateComponent: DateComponents, isCurrentMonth: Bool)] {
    guard weekDayIndexOfFirstDay > 0 else { return [] }
    var displayingDateComponents = [(DateComponents, Bool)]()
    
    for day in (1 ... weekDayIndexOfFirstDay).reversed() {
      if let lastMonthDate = Calendar.current.date(byAdding: .day, value: -day, to: self.startDate) {
        let dateComponents = lastMonthDate.changeToDateComponents()
        displayingDateComponents.append((dateComponents, false))
      }
    }
    
    return displayingDateComponents
  }
  private var currentMonthDateComponents: [(dateComponent: DateComponents, isCurrentMonth: Bool)] {
    var displayingDateComponents = [(DateComponents, Bool)]()
    
    for day in 0 ..< numberOfDaysInMonth {
      if let currentMonthDate = Calendar.current.date(byAdding: .day, value: day, to: self.startDate) {
        let dateComponents = currentMonthDate.changeToDateComponents()
        displayingDateComponents.append((dateComponents,true))
      }
    }
    
    return displayingDateComponents
  }
  private var nextMonthDateComponents: [(dateComponent: DateComponents, isCurrentMonth: Bool)] {
    var displayingDateComponents = [(DateComponents, Bool)]()
    
    if let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1,  to: self.startDate) {
      let  daysOfNextMonthToDisplay = Weekday.daysInWeek - Weekday(Calendar.current.component(.weekday, from: dateInNextMonth)).convertWeekdayIndexToMondayBased()
      
      guard daysOfNextMonthToDisplay < 7 else { return [] }
      
      for day in 0 ..< daysOfNextMonthToDisplay {
        if let nextMonthDate = Calendar.current.date(byAdding: .day, value: day, to: dateInNextMonth) {
          let dateComponents = nextMonthDate.changeToDateComponents()
          displayingDateComponents.append((dateComponents, false))
        }
      }
    }
    
    return displayingDateComponents
  }
  
  var currentMonthTitle: String { return "\(self.year)년 \(self.month)월" }
  var numberOfDaysToDisplay: Int { self.calendarDisplayingDateComponents.count }

  init(_ year: Int, _ month: Int) {
    self.year = year
    self.month = month
  }
  
  init(date: Date) {
    self.year = Calendar.current.component(.year, from: date)
    self.month = Calendar.current.component(.month, from: date)
  }
  
  func dateComponentsInformation(at index: Int) -> (DateComponents, Bool) {
    return calendarDisplayingDateComponents[index]
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
}
