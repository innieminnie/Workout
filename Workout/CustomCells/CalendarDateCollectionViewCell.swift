//
//  CalendarDateCollectionViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/02/19.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
  static let identifier = "calendarDateCollectionViewCell"
  
  var isCurrentMonth = true
  var isToday = false
  var dateInformation: DateInformation?
  
  @IBOutlet weak var dateBackgroundView: UIView!
  @IBOutlet weak var dateNumberLabel: UILabel!
  
  override var isSelected: Bool {
    didSet{
      if isSelected {
        DispatchQueue.main.async {
          self.dateBackgroundView.layer.borderColor = 0xBEC0C2.convertToRGB().cgColor
          self.dateBackgroundView.layer.borderWidth = 4
          self.dateNumberLabel.font = UIFont.Pretendard(type: .Bold, size: 17)
        }
      }
      else {
        DispatchQueue.main.async {
          self.dateBackgroundView.layer.borderColor = UIColor.white.cgColor
          self.dateBackgroundView.layer.borderWidth = 4
          self.dateNumberLabel.font = UIFont.Pretendard(type: .Regular, size: 15)
        }
      }
      
      if isToday {
        DispatchQueue.main.async {
          self.dateNumberLabel.textColor = 0x096DB6.convertToRGB()
        }
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRoutineData(_:)), name: Notification.Name("ReadRoutineData"), object: nil)
    
    self.dateBackgroundView.backgroundColor = .clear
    self.dateBackgroundView.layer.borderColor = UIColor.white.cgColor
    self.dateBackgroundView.layer.borderWidth = 4
  }
  
  override func prepareForReuse() {
    self.isToday = false
    self.isSelected = false
    
    self.dateBackgroundView.backgroundColor = .clear
    self.dateBackgroundView.layer.borderColor = UIColor.white.cgColor
    self.dateBackgroundView.layer.borderWidth = 4
    self.dateNumberLabel.textColor = .black
    self.dateNumberLabel.font = UIFont.Pretendard(type: .Regular, size: 15)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    dateBackgroundView.layer.cornerRadius = dateBackgroundView.frame.size.width / 2
    dateBackgroundView.layer.masksToBounds = true
  }
  
  func setUp(with information: (dateComponent: DateComponents, isCurrentMonth: Bool)) {
    guard let year = information.dateComponent.year,
          let month = information.dateComponent.month,
          let day = information.dateComponent.day else { return }
    
    self.dateInformation = DateInformation(year, month, day)
    self.isCurrentMonth = information.isCurrentMonth
    
    dateNumberLabel.text = "\(day)"
    setInitialUI()
  }
  
  private func setInitialUI() {
    isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
    
    self.dateBackgroundView.layer.borderWidth = 4
    
    updateUI()
  }
  
  private func updateUI() {
    if let dateInformation = dateInformation {
      if !routineManager.plan(of: dateInformation).isEmpty {
        DispatchQueue.main.async {
          self.dateBackgroundView.backgroundColor = 0xF58423.convertToRGB()
          self.dateNumberLabel.textColor = .white
        }
      } else {
        DispatchQueue.main.async {
          self.dateBackgroundView.backgroundColor = .clear
          self.isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
        }
      }
    }
    
    if isToday {
      DispatchQueue.main.async {
        self.dateNumberLabel.textColor = 0x096DB6.convertToRGB()
      }
    }
  }
  
  func updateRoutine() {
    self.updateData()
  }
  
  private func updateData() {
    if let dateInformation = dateInformation {
      routineManager.readRoutineData(from: dateInformation)
    }
  }
  
  @objc  private func checkRoutineData(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let dateInformation = userInfo["date"] as? DateInformation else {
      return
    }
    
    guard self.dateInformation == dateInformation else { return }
    updateUI()
  }
}
