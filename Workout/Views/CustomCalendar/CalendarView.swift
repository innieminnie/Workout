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
  
  enum ScrollDirection {
    case left
    case right
    case none
  }
  
  weak var delegate: CalendarViewDelegate?
  private let todayInformation = DateInformation(date: CalendarView.defaultDate)
  
  
  private let weekdaysView = WeekdaysView()
  private var selectedCell: CalendarDateCollectionViewCell?
  private lazy var rightButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.moveToNextMonth() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: ">", foregroundColor: .black, font: UIFont.Pretendard(type: .Bold, size: 20), buttonSize: .small)
    
    return button
  }()
  
  private lazy var contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delegate = self
    scrollView.contentSize.width = UIScreen.main.bounds.width * 3
    scrollView.contentSize.height = UIScreen.main.bounds.width
    
    return scrollView
  }()
  
  private lazy var monthSelectionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    stackView.addArrangedSubview(self.leftButton)
    stackView.addArrangedSubview(self.currentMonthLabel)
    stackView.addArrangedSubview(self.rightButton)
    
    return stackView
  }()
  
  private lazy var navigationStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
  
    stackView.addArrangedSubview(monthSelectionStackView)
    stackView.addArrangedSubview(calendarStateButton)
    
    return stackView
  }()
  
  private lazy var leftButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.moveToLastMonth() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: "<", foregroundColor: .black, font: UIFont.Pretendard(type: .Bold, size: 20), buttonSize: .small)
    
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
  private lazy var calendarStateButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.changeCalendarState() })
    button.translatesAutoresizingMaskIntoConstraints = false
    button.customizeConfiguration(with: "달력접기", foregroundColor: 0x096DB6.convertToRGB(), font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
    button.contentVerticalAlignment = .top
    button.contentHorizontalAlignment = .right
    
    return button
  }()
  
  private var previousMonthlyView = MonthlyPageCollectionView()
  private var currentMonthlyView = MonthlyPageCollectionView()
  private var nextMonthlyView = MonthlyPageCollectionView()
  
  private var monthArray = [MonthlyInformation]()
  private var scrollDirection: ScrollDirection = .none
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(navigationStackView)
    self.addSubview(weekdaysView)
    self.addSubview(contentScrollView)
    
    let monthlyCalendarArray = [previousMonthlyView, currentMonthlyView, nextMonthlyView]
    configureMonthlyCollectionViews(with: monthlyCalendarArray)
    monthArray = [MonthlyInformation(date: CalendarView.defaultDate).lastMonth(), MonthlyInformation(date: CalendarView.defaultDate), MonthlyInformation(date: CalendarView.defaultDate).nextMonth()]
    currentMonthLabel.text = monthArray[1].currentMonthTitle
    
    NSLayoutConstraint.activate([
      navigationStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      navigationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      navigationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      
      weekdaysView.topAnchor.constraint(equalTo: monthSelectionStackView.bottomAnchor, constant: 10),
      weekdaysView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      weekdaysView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      contentScrollView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: weekdaysView.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: weekdaysView.trailingAnchor),
      contentScrollView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 7) * 6),
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
  
  private func changeCalendarState() {
    if calendarStateButton.configuration?.title == "달력접기" {
      delegate?.calendarIsFolded(height: self.weekdaysView.frame.minY)
    } else {
      delegate?.calendarIsOpened()
      calendarStateButton.customizeConfiguration(with: "달력접기", foregroundColor: 0x096DB6.convertToRGB(), font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
      
      currentMonthLabel.text = self.monthArray[1].currentMonthTitle
      leftButton.isHidden = false
      rightButton.isHidden = false
    }
  }
  
  func foldCalendar() {
    guard let selectedCell = selectedCell else { return }
    guard let dateInformation = selectedCell.dateInformation else { return }
    
    calendarStateButton.customizeConfiguration(with: "달력펼치기", foregroundColor: 0x096DB6.convertToRGB(), font: UIFont.Pretendard(type: .Semibold, size: 17), buttonSize: .small)
    weekdaysView.isHidden = true
    contentScrollView.isHidden = true
    
    currentMonthLabel.text = "\(dateInformation.fullDate)"
    leftButton.isHidden = true
    rightButton.isHidden = true
  }
  
  func openCalendar() {
    weekdaysView.isHidden = false
    contentScrollView.isHidden = false
  }
  
  @objc private func moveToNextMonth() {
    UIView.animate(withDuration: 0.5) {
      self.contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0), animated: false)
    } completion: { _ in
      self.monthArray.forEach{ $0.changeToNextMonth() }
      self.delegate?.changedSelectedDay(to: nil)
      self.currentMonthlyView.reloadData()
      self.contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
      self.previousMonthlyView.reloadData()
      self.nextMonthlyView.reloadData()
      self.currentMonthLabel.text = self.monthArray[1].currentMonthTitle
    }
  }
  
  @objc private func moveToLastMonth() {
    UIView.animate(withDuration: 0.5) {
      self.contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 0, y: 0), animated: false)
    } completion: { _ in
      self.monthArray.forEach{ $0.changeToLastMonth() }
      self.delegate?.changedSelectedDay(to: nil)
      self.currentMonthlyView.reloadData()
      self.contentScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
      self.previousMonthlyView.reloadData()
      self.nextMonthlyView.reloadData()
      self.currentMonthLabel.text = self.monthArray[1].currentMonthTitle
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
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y != 0 {
      scrollView.contentOffset.y = 0
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    switch targetContentOffset.pointee.x {
    case CGFloat(0)..<CGFloat(UIScreen.main.bounds.width):
      scrollDirection = .left
    case CGFloat(UIScreen.main.bounds.width * 2)..<CGFloat(UIScreen.main.bounds.width * 3):
      scrollDirection = .right
    default:
      scrollDirection = .none
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    switch scrollDirection {
    case .left:
      moveToLastMonth()
    case .none:
      break
    case .right:
      moveToNextMonth()
    }
  }
}
