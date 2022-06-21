//
//  CalendarView.swift
//  Workout
//
//  Created by 강인희 on 2022/02/14.
//

import UIKit

class CaledarDateTapGesture: UITapGestureRecognizer {
  var tappedCell: CalendarDateCollectionViewCell?
}

protocol CalendarViewDelegate: AnyObject {
  func changedSelectedDay(to dateInformation: DateInformation)
}

class CalendarView: UIView {
  private let todayInformation = DateInformation(Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date()), Calendar.current.component(.day, from: Date()))
  
  private var selectedDayInformation: DateInformation?
  
  private var displayingMonthInformation = MonthlyInformation(Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date()))
  
  private let rightButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedNextMonthButton(sender:)), for: .touchUpInside)
    button.setTitle(">", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    return button
  }()
  
  private let leftButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedLastMonthButton(sender:)), for: .touchUpInside)
    button.setTitle("<", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    return button
  }()
  
  private let currentMonthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .black
    
    return label
  }()
  
  private let weekdaysLabel: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    for dayName in weekdays {
      stackView.addArrangedSubview(RoundedCornerLabelView(title: dayName))
    }
    
    return stackView
  }()
  
  private let monthlyPageCollectionView = MonthlyPageCollectionView()
  
  private var selectedCell: CalendarDateCollectionViewCell?
  
  weak var delegate: CalendarViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    selectedDayInformation = todayInformation
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(weekdaysLabel)
    self.addSubview(monthlyPageCollectionView)
    
    currentMonthLabel.text = displayingMonthInformation.currentDate
    monthlyPageCollectionView.dataSource = self
    monthlyPageCollectionView.delegate = self
    
    NSLayoutConstraint.activate([
      currentMonthLabel.topAnchor.constraint(equalTo: self.topAnchor),
      currentMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      rightButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      rightButton.leadingAnchor
        .constraint(equalTo: currentMonthLabel.trailingAnchor, constant: 10),
      
      leftButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      leftButton.trailingAnchor
        .constraint(equalTo: currentMonthLabel.leadingAnchor, constant: -10),
      
      weekdaysLabel.topAnchor.constraint(equalTo: currentMonthLabel.bottomAnchor, constant: 20),
      weekdaysLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      weekdaysLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      
      monthlyPageCollectionView.topAnchor.constraint(equalTo: weekdaysLabel.bottomAnchor, constant: 5),
      monthlyPageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      monthlyPageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      monthlyPageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func tappedNextMonthButton(sender: UIButton) {
    displayingMonthInformation.changeToNextMonth()
    currentMonthLabel.text = displayingMonthInformation.currentDate
    monthlyPageCollectionView.reloadData()
    monthlyPageCollectionView.layoutIfNeeded()
  }
  
  @objc func tappedLastMonthButton(sender: UIButton) {
    displayingMonthInformation.changeToLastMonth()
    currentMonthLabel.text = displayingMonthInformation.currentDate
    monthlyPageCollectionView.reloadData()
    monthlyPageCollectionView.layoutIfNeeded()
  }
  
  @objc private func cellTapped(gesture: CaledarDateTapGesture) {
    if let currentSelectedCell = selectedCell {
      currentSelectedCell.isSelected = false
    }
    
    if let currentTappedCell = gesture.tappedCell {
      currentTappedCell.isSelected = true
      self.selectedCell = currentTappedCell
    }
  
    selectedDayInformation = selectedCell?.dateInformation
    
    if let tappedDate = selectedDayInformation {
      delegate?.changedSelectedDay(to: tappedDate)
    }
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
extension CalendarView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayingMonthInformation.numberOfDaysToDisplay()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.identifier, for: indexPath) as? CalendarDateCollectionViewCell else {
      return UICollectionViewCell()
    }
  
    let firstDay = displayingMonthInformation.weekDayIndexOfFirstDay
    let numberOfDaysInCurrentMonth = displayingMonthInformation.numberOfDays
    let currentMonthCellRange = (firstDay..<firstDay + numberOfDaysInCurrentMonth)
    let dateInLastMonth = Calendar.current.date(byAdding: .month, value: -1,  to: displayingMonthInformation.startDate)
  
    guard let monthRange = Calendar.current.range(of: .day, in: .month, for: dateInLastMonth!) else {
      return UICollectionViewCell()
    }
  
    if indexPath.row < firstDay {
      let (year, month) = displayingMonthInformation.lastMonthInformation()
      let day = monthRange.last! - firstDay + indexPath.row + 1
      cell.dateInformation = DateInformation(year, month, day)
      
      cell.update(with: day, isCurrentMonth: false)
    } else if currentMonthCellRange.contains(indexPath.row) {
      let (year, month) = displayingMonthInformation.currentMonthInformation()
      let day = indexPath.row - firstDay + 1
      cell.dateInformation = DateInformation(year, month, day)
    
      if displayingMonthInformation.currentDate == todayInformation.currentDate
          && day == Calendar.current.component(.day, from: Date()) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        cell.isToday = true
        self.selectedCell = cell
      }
      
      cell.update(with: day, isCurrentMonth: true)
    } else {
      let (year, month) = displayingMonthInformation.nextMonthInformation()
      let day = indexPath.row - (numberOfDaysInCurrentMonth + firstDay) + 1
      cell.dateInformation = DateInformation(year, month, day)
      
      cell.update(with: day, isCurrentMonth: false)
    }
    
    let calendarDateTapGesture = CaledarDateTapGesture(target: self, action: #selector(cellTapped(gesture:)))
    calendarDateTapGesture.tappedCell = cell
    cell.addGestureRecognizer(calendarDateTapGesture)
    
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
