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
  func changedSelectedDay(to dateInformation: DateInformation?)
}

class CalendarView: UIView {
  private let todayInformation = DateInformation(Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date()), Calendar.current.component(.day, from: Date()))
  
  private var displayingMonthInformation = MonthlyInformation(Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date()))
  
  private lazy var rightButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedNextMonthButton), for: .touchUpInside)
    button.setTitle(">", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.Pretendard(type: .Bold, size: 20)
    
    return button
  }()
  
  private lazy var leftButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedLastMonthButton), for: .touchUpInside)
    button.setTitle("<", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 20)
    return button
  }()
  
  private let currentMonthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    label.textColor = .black
    
    return label
  }()
  
  private let weekdaysView = WeekdaysView()
  
  private let monthlyPageCollectionView = MonthlyPageCollectionView()
  
  private var selectedCell: CalendarDateCollectionViewCell?
  
  weak var delegate: CalendarViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(weekdaysView)
    self.addSubview(monthlyPageCollectionView)
    
    currentMonthLabel.text = displayingMonthInformation.currentDate
    monthlyPageCollectionView.dataSource = self
    monthlyPageCollectionView.delegate = self
    
    configureSwipeGestures()

    NSLayoutConstraint.activate([
      currentMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      currentMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      rightButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      rightButton.leadingAnchor
        .constraint(equalTo: self.trailingAnchor, constant: -50),
      
      leftButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      leftButton.trailingAnchor
        .constraint(equalTo: self.leadingAnchor, constant: 50),
      
      weekdaysView.topAnchor.constraint(equalTo: currentMonthLabel.bottomAnchor, constant: 10),
      weekdaysView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      weekdaysView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      
      monthlyPageCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
      monthlyPageCollectionView.leadingAnchor.constraint(equalTo: weekdaysView.leadingAnchor),
      monthlyPageCollectionView.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
      monthlyPageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureSwipeGestures() {
    let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(tappedLastMonthButton))
    swipeRightGestureRecognizer.direction = .right
    self.addGestureRecognizer(swipeRightGestureRecognizer)
    
    let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(tappedNextMonthButton))
    swipeLeftGestureRecognizer.direction = .left
    self.addGestureRecognizer(swipeLeftGestureRecognizer)
  }
  
  func updateSelectedCell() {
    if let selectedCell = selectedCell {
      selectedCell.updateStatus()
    }
  }
  
  func reloadUserData() {
    DispatchQueue.main.async {
      self.monthlyPageCollectionView.reloadData()
    }
  }
  
  @objc private func tappedNextMonthButton() {
    displayingMonthInformation.changeToNextMonth()
    currentMonthLabel.text = displayingMonthInformation.currentDate
    delegate?.changedSelectedDay(to: nil)
    
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {
        self.monthlyPageCollectionView.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
        self.monthlyPageCollectionView.alpha = 0
      } completion: { _ in
        self.monthlyPageCollectionView.reloadData()
        self.monthlyPageCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3) {
          self.monthlyPageCollectionView.alpha = 1
        }
      }
    }
  }
  
  @objc private func tappedLastMonthButton() {
    displayingMonthInformation.changeToLastMonth()
    currentMonthLabel.text = displayingMonthInformation.currentDate
    delegate?.changedSelectedDay(to: nil)
    
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {
        self.monthlyPageCollectionView.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
        self.monthlyPageCollectionView.alpha = 0
      } completion: { _ in
        self.monthlyPageCollectionView.reloadData()
        self.monthlyPageCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3) {
          self.monthlyPageCollectionView.alpha = 1
        }
      }
    }
  }
  
  @objc private func cellTapped(gesture: CaledarDateTapGesture) {
    if let currentSelectedCell = selectedCell {
      currentSelectedCell.isSelected = false
    }
    
    if let currentTappedCell = gesture.tappedCell {
      currentTappedCell.isSelected = true
      self.selectedCell = currentTappedCell
    }
    
    if let selectedDayInformation = selectedCell?.dateInformation {
      delegate?.changedSelectedDay(to: selectedDayInformation)
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
    
    let numberOfDaysInCurrentMonth = displayingMonthInformation.numberOfDays
    let currentMonthCellRange = (0..<numberOfDaysInCurrentMonth).map { $0 + displayingMonthInformation.weekDayIndexOfFirstDay }
    
    if indexPath.row < displayingMonthInformation.weekDayIndexOfFirstDay {
      let (lastYear, lastMonth) = displayingMonthInformation.lastMonthInformation()
      let day = MonthlyInformation.numberOfDays(lastYear, lastMonth) - displayingMonthInformation.weekDayIndexOfFirstDay + indexPath.row + 1
      cell.dateInformation = DateInformation(lastYear, lastMonth, day)
      
      cell.update(with: day, isCurrentMonth: false)
    } else if currentMonthCellRange.contains(indexPath.row) {
      let (year, month) = displayingMonthInformation.currentMonthInformation()
      let day = indexPath.row - displayingMonthInformation.weekDayIndexOfFirstDay + 1
      cell.dateInformation = DateInformation(year, month, day)
      
      if displayingMonthInformation.currentDate == todayInformation.currentMonthlyDate
          && day == Calendar.current.component(.day, from: Date()) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        cell.isToday = true
        self.selectedCell = cell
        delegate?.changedSelectedDay(to: todayInformation)
      }
      
      cell.update(with: day, isCurrentMonth: true)
    } else {
      let (nextYear, nextMonth) = displayingMonthInformation.nextMonthInformation()
      let day = indexPath.row - (numberOfDaysInCurrentMonth + displayingMonthInformation.weekDayIndexOfFirstDay) + 1
      cell.dateInformation = DateInformation(nextYear, nextMonth, day)
      
      cell.update(with: day, isCurrentMonth: false)
    }
    
    cell.updateStatus()
    
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
