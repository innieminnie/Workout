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
  private enum CalendarState: String {
    case folded = "달력펼치기"
    case opened = "달력접기"
  }
  
  static let defaultDate = Date()
  
  private let todayInformation = DateInformation(date: CalendarView.defaultDate)
  private var displayingMonthInformation = MonthlyInformation(date: CalendarView.defaultDate) {
    didSet {
      currentMonthLabel.text = displayingMonthInformation.currentMonthTitle
    }
  }
  private var calendarState: CalendarState = .opened {
    didSet {
      self.calendarStateButton.customizeConfiguration(with: self.calendarState.rawValue, foregroundColor: .black, font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
      if calendarState == .opened {
        rightButton.isHidden = false
        leftButton.isHidden = false
      } else {
        rightButton.isHidden = true
        leftButton.isHidden = true
      }
    }
  }
  weak var delegate: CalendarViewDelegate?
  
  private let currentMonthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    label.textColor = .black
    
    return label
  }()
  private lazy var rightButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.moveToNextMonth() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: ">", foregroundColor: .black, font: UIFont.Pretendard(type: .Bold, size: 20), buttonSize: .small)
    
    return button
  }()
  private lazy var leftButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.moveToLastMonth() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: "<", foregroundColor: .black, font: UIFont.Pretendard(type: .Bold, size: 20), buttonSize: .small)
    
    return button
  }()
  private lazy var calendarStateButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.updateCalendarState() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: self.calendarState.rawValue, foregroundColor: .black, font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
    button.contentVerticalAlignment = .top
    button.contentHorizontalAlignment = .right
    
    return button
  }()
  private let weekdaysView = WeekdaysView()
  private let monthlyPageCollectionView = MonthlyPageCollectionView()
  private var selectedCell: CalendarDateCollectionViewCell?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(calendarStateButton)
    self.addSubview(weekdaysView)
    self.addSubview(monthlyPageCollectionView)
    
    currentMonthLabel.text = displayingMonthInformation.currentMonthTitle
    monthlyPageCollectionView.dataSource = self
    monthlyPageCollectionView.delegate = self
    
    configureSwipeGestures()
    
    NSLayoutConstraint.activate([
      currentMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      currentMonthLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
      currentMonthLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -10),
      
      rightButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      
      leftButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      leftButton.trailingAnchor
        .constraint(equalTo: self.leadingAnchor, constant: 50),
      
      calendarStateButton.centerYAnchor.constraint(equalTo: currentMonthLabel.centerYAnchor),
      calendarStateButton.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
      
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
  
  func updateSelectedCell() {
    if let selectedCell = selectedCell {
      selectedCell.updateRoutine()
    }
  }
  
  func reloadUserData() {
    DispatchQueue.main.async {
      self.monthlyPageCollectionView.reloadData()
    }
  }
  
  private func configureSwipeGestures() {
    let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(moveToLastMonth))
    swipeRightGestureRecognizer.direction = .right
    self.addGestureRecognizer(swipeRightGestureRecognizer)
    
    let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(moveToNextMonth))
    swipeLeftGestureRecognizer.direction = .left
    self.addGestureRecognizer(swipeLeftGestureRecognizer)
  }
  
  private func updateCalendarState() {
    self.calendarState = self.calendarState == .opened ? .folded : .opened
  }
  
  @objc private func moveToNextMonth() {
    displayingMonthInformation.changeToNextMonth()
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
  
  @objc private func moveToLastMonth() {
    displayingMonthInformation.changeToLastMonth()
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
    return displayingMonthInformation.numberOfDaysToDisplay
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.identifier, for: indexPath) as? CalendarDateCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let cellDateInfo = displayingMonthInformation.dateComponentsInformation(at: indexPath.row)
    cell.setUp(with: cellDateInfo)
   
    if cell.dateInformation == todayInformation {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
      cell.isToday = true
      self.selectedCell = cell
      delegate?.changedSelectedDay(to: todayInformation)
    }
    
    let calendarDateTapGesture = CaledarDateTapGesture(target: self, action: #selector(cellTapped(gesture:)))
    calendarDateTapGesture.tappedCell = cell
    cell.addGestureRecognizer(calendarDateTapGesture)
    
    return cell
  }
}
