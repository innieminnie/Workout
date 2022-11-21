//
//  SettingTableViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/11/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
  static let identifier = "settingTableViewCell"
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setUp(with title: String) {
    if title == "계정" {
      self.titleLabel.text = AuthenticationManager.userEmail
    } else {
      self.titleLabel.text = title
    }
  }
}
