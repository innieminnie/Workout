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
  }
  
  func update(with number: Int, isCurrentMonth: Bool) {
    if isCurrentMonth {
      self.dateNumberLabel.textColor = .systemPink
    } else {
      self.dateNumberLabel.textColor = .systemGray
    }
    
    dateNumberLabel.text = "\(number)"
  }
  
}
