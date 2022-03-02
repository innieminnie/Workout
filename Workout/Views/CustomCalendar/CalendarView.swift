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
    label.textColor = .white
    
    return label
  }()
  
  private let monthlyPageCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    
    collectionView.backgroundColor = .white
    let nib = UINib(nibName: "CalendarDateCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.allowsMultipleSelection = false
    
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    currentMonth = Calendar.current.component(.month, from: Date())
    currentYear = Calendar.current.component(.year, from: Date())
    
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(monthlyPageCollectionView)
    
    currentMonthLabel.text = " \(currentYear)년 \(currentMonth)월 "
    monthlyPageCollectionView.delegate = self
    monthlyPageCollectionView.dataSource = self
    
    NSLayoutConstraint.activate([
      currentMonthLabel.topAnchor.constraint(equalTo: self.topAnchor),
      currentMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      rightButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      rightButton.leadingAnchor
        .constraint(equalTo: currentMonthLabel.trailingAnchor, constant: 10),
      
      leftButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      leftButton.trailingAnchor
        .constraint(equalTo: currentMonthLabel.leadingAnchor, constant: -10),
      
      monthlyPageCollectionView.topAnchor.constraint(equalTo: currentMonthLabel.bottomAnchor, constant: 10),
      monthlyPageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      monthlyPageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      monthlyPageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
    monthlyPageCollectionView.reloadData()
  }
  
  @objc func tappedLastMonthButton(sender: UIButton) {
    currentMonth = (currentMonth + 12) % 13
    
    if currentMonth == 0 {
      currentMonth = 12
      currentYear -= 1
    }
    
    currentMonthLabel.text = " \(currentYear)년 \(currentMonth)월 "
    monthlyPageCollectionView.reloadData()
  }
  
  private func numberOfDaysInCurrentMonth() -> Int {
    let dayName = weekdays[(getFirstDayOfTheMonth())]
    let dateComponents = DateComponents(year: currentYear, month: currentMonth)
    let date = Calendar.current.date(from: dateComponents)
    
    guard let monthRange = Calendar.current.range(of: .day, in: .month, for: date!) else {
      return 0
    }
    
    print("1일은 \(dayName)요일, \(currentMonth)의 날짜수는 \(String(describing: monthRange))일")
    return monthRange.count
  }
  
  private func numberOfDaysInLastMonth() -> Int {
    var lastMonth = (currentMonth + 12) % 13
    var year = currentYear
    
    if lastMonth == 0 {
      lastMonth = 12
      year = currentYear - 1
    }
    
    let dateComponents = DateComponents(year: year, month: lastMonth)
    let date = Calendar.current.date(from: dateComponents)
    
    guard let monthRange = Calendar.current.range(of: .day, in: .month, for: date!) else {
      return 0
    }

    return monthRange.count
  }
  
  private func getFirstDayOfTheMonth() -> Int {
    let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
    return day
  }
}
extension CalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth =  monthlyPageCollectionView.frame.width / 7
    let cellHeight = cellWidth
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
extension CalendarView: UICollectionViewDelegate {
  
}
extension CalendarView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return weekdays.count * 6
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.identifier, for: indexPath) as? CalendarDateCollectionViewCell else {
      return UICollectionViewCell()
    }
  
    let firstDay = getFirstDayOfTheMonth()
    let numberOfDaysInCurrentMonth = numberOfDaysInCurrentMonth()
    let currentMonthCellRange = (firstDay..<firstDay + numberOfDaysInCurrentMonth)
    let numberOfDaysInLastMonth = numberOfDaysInLastMonth()
    
    if indexPath.row < firstDay {
      cell.update(with: numberOfDaysInLastMonth - (firstDay - indexPath.row - 1), isCurrentMonth: false)
    } else if currentMonthCellRange.contains(indexPath.row) {
      cell.update(with: indexPath.row - firstDay + 1, isCurrentMonth: true)
    } else {
      cell.update(with: indexPath.row - (numberOfDaysInCurrentMonth + firstDay) + 1, isCurrentMonth: false)
    }
    
    return cell
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
    return Calendar.current.component(.weekday, from: self) - 1
  }
  
  var firstDayOfTheMonth: Date {
    get {
      Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
  }
}
