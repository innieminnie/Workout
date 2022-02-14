//
//  CalendarView.swift
//  Workout
//
//  Created by 강인희 on 2022/02/14.
//

import UIKit

class CalendarView: UIView {
  private var weekdays = ["일", "월", "화", "수", "목", "금", "토"]
  private var currentMonth = 1
  private var currentYear = 0
  
  private let rightButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedNextMonthButton(sender:)), for: .touchUpInside)
    button.setTitle(">", for: .normal)
    
    return button
  }()
  
  private let leftButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedLastMonthButton(sender:)), for: .touchUpInside)
    button.setTitle("<", for: .normal)
    
    return button
  }()
  
  private let currentMonthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .red
    currentMonth = Calendar.current.component(.month, from: Date()) //- 1
    currentYear = Calendar.current.component(.year, from: Date())
    
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    
    currentMonthLabel.text = " \(currentYear)년 \(currentMonth)월 "
    
    NSLayoutConstraint.activate([
      currentMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      currentMonthLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      rightButton.topAnchor.constraint(equalTo: currentMonthLabel.topAnchor),
      rightButton.leadingAnchor
        .constraint(equalTo: currentMonthLabel.trailingAnchor, constant: 10),
      leftButton.topAnchor.constraint(equalTo: currentMonthLabel.topAnchor),
      leftButton.trailingAnchor
        .constraint(equalTo: currentMonthLabel.leadingAnchor, constant: -10),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func tappedNextMonthButton(sender: UIButton) {
    currentMonth = (currentMonth + 1) % 13
    
    if currentMonth == 0 {
      currentMonth = 1
      currentYear += 1
    }
    
    currentMonthLabel.text = " \(currentYear)년 \(currentMonth)월 "
    didChangeMonth()
  }
  
  @objc func tappedLastMonthButton(sender: UIButton) {
    currentMonth = (currentMonth + 12) % 13
    
    if currentMonth == 0 {
      currentMonth = 12
      currentYear -= 1
    }
    
    currentMonthLabel.text = " \(currentYear)년 \(currentMonth)월 "
    didChangeMonth()
  }
  
  private func didChangeMonth() {
    let dayName = weekdays[(getFirstDayOfTheMonth() - 1)]
    let dateComponents = DateComponents(year: currentYear, month: currentMonth)
    let date = Calendar.current.date(from: dateComponents)
    let monthRange = Calendar.current.range(of: .day, in: .month, for: date!)
    print("1일은 \(dayName)요일, \(currentMonth)의 날짜수는 \(String(describing: monthRange))일")
  }
  
  private func getFirstDayOfTheMonth() -> Int {
    let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
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
    return Calendar.current.component(.weekday, from: self)
  }
  
  var firstDayOfTheMonth: Date {
    get {
      Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
  }
}

