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
    // Initialization code
    self.contentView.backgroundColor = .systemPink
  }
  
  func update(with number: Int, isCurrentMonth: Bool) {
    if isCurrentMonth {
      self.contentView.backgroundColor = .systemPink
    } else {
      self.contentView.backgroundColor = .systemGray
    }
    
    dateNumberLabel.text = "\(number)"
  }
  
}
