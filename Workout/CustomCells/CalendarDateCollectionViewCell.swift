//
//  CalendarDateCollectionViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/02/19.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
  static let identifier = "calendarDateCollectionViewCell"
  private var isCurrentMonth = true
  var isToday = false
  var dateInformation: DateInformation?
  
  @IBOutlet weak var circleBackgroundView: UIView!
  @IBOutlet weak var dateNumberLabel: UILabel!
  
  override var isSelected: Bool {
    didSet{
      if isSelected {
        self.circleBackgroundView.backgroundColor = .systemGray3
        self.dateNumberLabel.textColor = .white
      }
      else {
        self.circleBackgroundView.backgroundColor = .clear
        self.dateNumberLabel.textColor = isCurrentMonth ? .black : .systemGray
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRoutineData(_:)), name: Notification.Name("ReadRoutineData"), object: nil)
  }
  
  override func prepareForReuse() {
    self.isToday = false
    self.isSelected = false
    
    self.circleBackgroundView.backgroundColor = .clear
    self.circleBackgroundView.layer.borderColor = UIColor.clear.cgColor
    self.circleBackgroundView.layer.borderWidth = 0
    self.dateNumberLabel.textColor = .black
    self.dateNumberLabel.font = UIFont.systemFont(ofSize: 15)
  }
  
  func update(with number: Int, isCurrentMonth: Bool) {
    self.isCurrentMonth = isCurrentMonth
    isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
    
    if isToday {
      self.isSelected = true
      self.dateNumberLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    dateNumberLabel.text = "\(number)"
  }
  
  func updateStatus() {
    if let dateInformation = dateInformation {
      routineManager.readData(from: dateInformation)
    }
  }
  
  @objc  private func checkRoutineData(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let dateInformation = userInfo["date"] as? DateInformation,
          let dailyRoutine = userInfo["dailyRoutine"] as? [PlannedWorkout] else {
      return
    }
    
    if self.dateInformation == dateInformation && !dailyRoutine.isEmpty {
      DispatchQueue.main.async {
        self.circleBackgroundView.layer.borderColor = UIColor.black.cgColor
        self.circleBackgroundView.layer.borderWidth = 1
      }
    }
  }
}
