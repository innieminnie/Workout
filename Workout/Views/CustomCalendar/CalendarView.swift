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

class CalendarView: UIView {
  static let defaultDate = Date()
  
  weak var delegate: CalendarViewDelegate?
  
  private let todayInformation = DateInformation(date: CalendarView.defaultDate)
  private var displayingMonthInformation = MonthlyInformation(date: CalendarView.defaultDate) {
    didSet {
      currentMonthLabel.text = displayingMonthInformation.currentMonthTitle
    }
  }
  
  private let currentMonthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    label.textColor = .black
    
    return label
  }()
  private let weekdaysView = WeekdaysView()
  private var selectedCell: CalendarDateCollectionViewCell?
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
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.foldCalendar() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: "달력접기", foregroundColor: .black, font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
    button.contentVerticalAlignment = .top
    button.contentHorizontalAlignment = .right
    
    return button
  }()
  
  private lazy var contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.delegate = self
    scrollView.contentSize.width = UIScreen.main.bounds.width * 3
    scrollView.contentSize.height = UIScreen.main.bounds.width
    scrollView.backgroundColor = .red
    return scrollView
  }()
  
  private var previousMonthlyView = MonthlyPageCollectionView()
  private var currentMonthlyView = MonthlyPageCollectionView()
  private var nextMonthlyView = MonthlyPageCollectionView()
  
  private var monthArray = [MonthlyInformation]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(currentMonthLabel)
    self.addSubview(rightButton)
    self.addSubview(leftButton)
    self.addSubview(calendarStateButton)
    self.addSubview(weekdaysView)
    self.addSubview(contentScrollView)
    
    let monthlyCalendarArray = [previousMonthlyView, currentMonthlyView, nextMonthlyView]
    configureMonthlyCollectionViews(with: monthlyCalendarArray)
    monthArray = [displayingMonthInformation.lastMonth(), displayingMonthInformation, displayingMonthInformation.nextMonth()]
        configureSwipeGestures()
    currentMonthLabel.text = displayingMonthInformation.currentMonthTitle
    
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
      weekdaysView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      weekdaysView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      contentScrollView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: weekdaysView.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
      contentScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
      contentScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureMonthlyCollectionViews(with array: [MonthlyPageCollectionView]) {
    for (index, collectionView) in array.enumerated() {
      collectionView.dataSource = self
      collectionView.delegate = self
      
      let xPosition = UIScreen.main.bounds.width * CGFloat(index)
      collectionView.frame = CGRect(x: xPosition, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
      contentScrollView.addSubview(collectionView)
    }
    
    contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
  }
  
    private func configureSwipeGestures() {
      let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(moveToLastMonth))
      swipeRightGestureRecognizer.direction = .right
      currentMonthlyView.addGestureRecognizer(swipeRightGestureRecognizer)
  
      let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action:  #selector(moveToNextMonth))
      swipeLeftGestureRecognizer.direction = .left
      currentMonthlyView.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
  
  private func foldCalendar() {
    delegate?.calendarIsFolded()
  }
  
  @objc private func moveToNextMonth() {
        displayingMonthInformation.changeToNextMonth()
        delegate?.changedSelectedDay(to: nil)
    //자동 오른쪽으로 스크롤 구현
  }
  
  @objc private func moveToLastMonth() {
        displayingMonthInformation.changeToLastMonth()
        delegate?.changedSelectedDay(to: nil)
    // 자동왼쪽스크롤구현
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
  
  func updateSelectedCell() {
    if let selectedCell = selectedCell {
      selectedCell.updateRoutine()
    }
  }
  
  func reloadUserData() {
    DispatchQueue.main.async {
      self.previousMonthlyView.reloadData()
      self.currentMonthlyView.reloadData()
      self.nextMonthlyView.reloadData()
    }
  }
}
extension CalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth =  currentMonthlyView.frame.width / 7
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
    let xPoint = collectionView.frame.minX
    let index = Int(xPoint / UIScreen.main.bounds.width)
    return monthArray[index].numberOfDaysToDisplay
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.identifier, for: indexPath) as? CalendarDateCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let xPoint = collectionView.frame.minX
    let index = Int(xPoint / UIScreen.main.bounds.width)
    let cellDateInfo = monthArray[index].dateComponentsInformation(at: indexPath.row)
    cell.setUp(with: cellDateInfo)
    
    if cell.dateInformation == todayInformation && collectionView.frame.minX == UIScreen.main.bounds.width {
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
extension CalendarView: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    switch targetContentOffset.pointee.x {
    case CGFloat(0)..<CGFloat(UIScreen.main.bounds.width):
      displayingMonthInformation.changeToLastMonth()
      monthArray[0].changeToLastMonth()
      monthArray[1].changeToLastMonth()
      monthArray[2].changeToLastMonth()
     
    case CGFloat(UIScreen.main.bounds.width * 2)..<CGFloat(UIScreen.main.bounds.width * 3):
      displayingMonthInformation.changeToNextMonth()
      monthArray[0].changeToNextMonth()
      monthArray[1].changeToNextMonth()
      monthArray[2].changeToNextMonth()
    default:
      break
    }
    
    DispatchQueue.main.async {
      self.reloadUserData()
      self.delegate?.changedSelectedDay(to: nil)
    }
  }
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      DispatchQueue.main.async {
        self.contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
      }
    }
}
