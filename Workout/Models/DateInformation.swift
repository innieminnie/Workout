//
//  DateInformation.swift
//  Workout
//
//  Created by 강인희 on 2022/03/27.
//

import Foundation

struct DateInformation {
  private var year: Int
  private var month: Int
  private var day: Int
  var currentDate: String {
    return "\(self.year)년 \(self.month)월"
  }
  
  init(_ year: Int, _ month: Int, _ day: Int) {
    self.year = year
    self.month = month
    self.day = day
  }
  
  
}