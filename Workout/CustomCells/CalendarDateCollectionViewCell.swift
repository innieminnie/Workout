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
  
  @IBOutlet weak var dateBackgroundView: UIView!
  @IBOutlet weak var dateNumberLabel: UILabel!
  
  override var isSelected: Bool {
    didSet{
      if isSelected {
        DispatchQueue.main.async {
          self.dateBackgroundView.layer.borderColor = 0xBEC0C2.converToRGB().cgColor
          self.dateBackgroundView.layer.borderWidth = 4
          self.dateNumberLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
      }
      else {
        DispatchQueue.main.async {
          self.dateBackgroundView.layer.borderColor = UIColor.white.cgColor
          self.dateBackgroundView.layer.borderWidth = 4
          self.dateNumberLabel.font = UIFont.systemFont(ofSize: 15)
        }
      }
      
      if isToday {
        DispatchQueue.main.async {
          self.dateNumberLabel.textColor = 0x096DB6.converToRGB()
        }
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
    
    self.dateBackgroundView.backgroundColor = .clear
    self.dateBackgroundView.layer.borderColor = UIColor.clear.cgColor
    self.dateBackgroundView.layer.borderWidth = 0
    self.dateNumberLabel.textColor = .black
    self.dateNumberLabel.font = UIFont.systemFont(ofSize: 15)
  }
  
  func update(with number: Int, isCurrentMonth: Bool) {
    self.isCurrentMonth = isCurrentMonth
    isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
    
    self.dateBackgroundView.layer.borderColor = UIColor.white.cgColor
    self.dateBackgroundView.layer.borderWidth = 4
    
    if isToday {
      self.isSelected = true
      self.dateBackgroundView.layer.borderColor = 0xBEC0C2.converToRGB().cgColor
    }
    
    dateNumberLabel.text = "\(number)"
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    dateBackgroundView.layer.cornerRadius = dateBackgroundView.frame.size.width / 2
    dateBackgroundView.layer.masksToBounds = true
  }
  
  func updateStatus() {
    if let dateInformation = dateInformation {
      routineManager.readRoutineData(from: dateInformation)
    }
  }
  
  @objc  private func checkRoutineData(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let dateInformation = userInfo["date"] as? DateInformation,
          let dailyRoutine = userInfo["dailyRoutine"] as? [PlannedWorkout] else {
      return
    }
    
    if self.dateInformation == dateInformation {
      if !dailyRoutine.isEmpty {
        DispatchQueue.main.async {
          self.dateBackgroundView.backgroundColor = 0xF58423.converToRGB()
          self.dateNumberLabel.textColor = .white
        }
      } else {
        DispatchQueue.main.async {
          self.dateBackgroundView.backgroundColor = .clear
          self.isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
        }
      }
      
      if isToday {
        DispatchQueue.main.async {
          self.dateNumberLabel.textColor = 0x096DB6.converToRGB()
        }
      }
    }
  }
}
