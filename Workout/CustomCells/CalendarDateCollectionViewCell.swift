//
//  CalendarDateCollectionViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/02/19.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
  static let identifier = "calendarDateCollectionViewCell"
  
  @IBOutlet weak var dateNumberLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 13
  }
  
  override func prepareForReuse() {
    self.backgroundColor = .clear
  }
  
  func update(with number: Int, isCurrentMonth: Bool, isToday: Bool) {
    isCurrentMonth ? (self.dateNumberLabel.textColor = .black) : (self.dateNumberLabel.textColor = .systemGray)
    isToday ? (self.backgroundColor = .systemPurple) : (self.backgroundColor = .clear)
    dateNumberLabel.text = "\(number)"
  }
  
}
