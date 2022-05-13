//
//  CalendarView.swift
//  Workout
//
//  Created by 강인희 on 2022/02/14.
//

import UIKit

class CalendarView: UIView {
  private let todayInformation = DateInformation(Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date()), Calendar.current.component(.day, from: Date()))
  private var selectedDayInformation: DateInformation?
  var selectedIndex: IndexPath?
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    selectedDayInformation = todayInformation
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .red
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(weekdaysLabel)
    self.addSubview(monthlyPageCollectionView)
    
    currentMonthLabel.text = displayingMonthInformation.currentDate
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
    self.selectedIndex = nil
  }
  
  @objc func tappedLastMonthButton(sender: UIButton) {
    displayingMonthInformation.changeToLastMonth()
    currentMonthLabel.text = displayingMonthInformation.currentDate
    monthlyPageCollectionView.reloadData()
    self.selectedIndex = nil
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDateCollectionViewCell else { return }
    cell.isSelected = true
    
    if let previousIndex = self.selectedIndex{
      let previousSelectedCell = collectionView.cellForItem(at: previousIndex)
      previousSelectedCell?.isSelected = false
    }
    
    self.selectedIndex = indexPath
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
      cell.update(with: monthRange.last! - firstDay + indexPath.row + 1, isCurrentMonth: false)
    } else if currentMonthCellRange.contains(indexPath.row) {
      cell.update(with: indexPath.row - firstDay + 1, isCurrentMonth: true)
      
      if displayingMonthInformation.currentDate == todayInformation.currentDate
          && (indexPath.row - firstDay + 1) == Calendar.current.component(.day, from: Date()) {
        cell.isToday = true
        cell.isSelected = true
        cell.update(with: indexPath.row - firstDay + 1, isCurrentMonth: true)
      }
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
