//
//  DateInformation.swift
//  Workout
//
//  Created by 강인희 on 2022/03/27.
//

import Foundation

struct DateInformation: Hashable, Codable {
  private var year: Int
  private var month: Int
  private var day: Int
  private var weekdayName: String {
    let dateComponent = DateComponents(calendar: Calendar.current, year: self.year, month: self.month, day: self.day)
    let date = dateComponent.date!
    let weekday = Weekday(Calendar.current.component(.weekday, from: date))
  
    return weekday  .weekdayName()
  }
  
  
  var currentMonthlyDate: String {
    return "\(self.year)년 \(self.month)월"
  }
  var fullDate: String {
    return "\(self.year)년 \(self.month)월 \(self.day)일 \(self.weekdayName)"
  }
  
  enum CodingKeys: String, CodingKey {
    case year
    case month
    case day
  }
  
  init(_ year: Int, _ month: Int, _ day: Int) {
    self.year = year
    self.month = month
    self.day = day
  }
  
  init(date: Date) {
    self.year = Calendar.current.component(.year, from: date)
    self.month = Calendar.current.component(.month, from: date)
    self.day = Calendar.current.component(.day, from: date)
  }
}
