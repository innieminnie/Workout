//
//  CalendarDateCollectionViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/02/19.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
  static let identifier = "calendarDateCollectionViewCell"
  var isToday = false
  var dateInformation: DateInformation?
  
  @IBOutlet weak var dateNumberLabel: UILabel!
  
  override var isSelected: Bool {
    didSet{
      if isSelected {
        self.backgroundColor = .systemGray5
      }
      else {
        self.backgroundColor = .clear
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 13
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRoutineData(_:)), name: Notification.Name("ReadRoutineData"), object: nil)
  }
  
  override func prepareForReuse() {
    self.isToday = false
    self.isSelected = false
    self.backgroundColor = .clear
    self.dateNumberLabel.textColor = .black
  }
  
  func update(with number: Int, isCurrentMonth: Bool) {
    isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
    
    if isToday {
      self.isSelected = true
      self.dateNumberLabel.textColor = .systemRed
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
        self.backgroundColor = .red
      }
    }
  }
}
