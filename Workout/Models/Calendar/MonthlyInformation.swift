//
//  MonthInformation.swift
//  Workout
//
//  Created by 강인희 on 2022/03/03.
//

import Foundation

class MonthlyInformation {
  var currentMonthTitle: String {
    return "\(self.dateComponent.year!)년 \(self.dateComponent.month!)월"
  }
  var numberOfDaysToDisplay: Int { self.calendarDisplayingDateComponents.count }
  
  private var dateComponent: DateComponents
  private var startDate: Date {
    let currentMonthStartDateComponents = DateComponents(year: self.dateComponent.year!, month: self.dateComponent.month!, day: 1)
    let date = Calendar.current.date(from: currentMonthStartDateComponents)
    
    return date!
  }
  private var numberOfDaysInMonth: Int {
    guard let date = Calendar.current.date(from: self.dateComponent),
          let interval = Calendar.current.dateInterval(of: .month, for: date),
          let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day else { return -1 }
  
    return days
  }
  private var weekDayIndexOfFirstDay: Int {
    return Weekday(Calendar.current.component(.weekday, from: self.startDate)).mondayBasedIndex()
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
      let  daysOfNextMonthToDisplay = Weekday.daysInWeek - Weekday(Calendar.current.component(.weekday, from: dateInNextMonth)).mondayBasedIndex()
      
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
  
  init(date: Date) {
    self.dateComponent = MonthlyInformation.makeMonthlyDateComponent(date: date)
  }
  
  private static func makeMonthlyDateComponent(date: Date?) -> DateComponents {
    let year = Calendar.current.component(.year, from: date!)
    let month = Calendar.current.component(.month, from: date!)
    
    return DateComponents(year: year, month: month)
  }
  
  func dateComponentsInformation(at index: Int) -> (DateComponents, Bool) {
    return calendarDisplayingDateComponents[index]
  }
  
  func changeToNextMonth() {
    let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1,  to: self.startDate)
    self.dateComponent = MonthlyInformation.makeMonthlyDateComponent(date: dateInNextMonth!)
  }
  
  func changeToLastMonth() {
    let dateInLastMonth = Calendar.current.date(byAdding: .month, value: -1,  to: self.startDate)
    self.dateComponent = MonthlyInformation.makeMonthlyDateComponent(date: dateInLastMonth!)
  }
  
  func nextMonth() -> MonthlyInformation {
    let dateInNextMonth = Calendar.current.date(byAdding: .month, value: 1,  to: self.startDate)
    return MonthlyInformation(date: dateInNextMonth!)
  }
  
  func lastMonth() -> MonthlyInformation {
    let dateInLastMonth = Calendar.current.date(byAdding: .month, value: -1,  to: self.startDate)
    return MonthlyInformation(date: dateInLastMonth!)
  }
}
