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
        self.backgroundColor = .systemGray
      }
      else {
        self.backgroundColor = .clear
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 13
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
      self.backgroundColor = .systemGray
      self.dateNumberLabel.textColor = .systemRed
    }
    
    dateNumberLabel.text = "\(number)"
  }
  
}
