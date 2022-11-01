//
//  Extensions.swift
//  Workout
//
//  Created by 강인희 on 2022/06/30.
//

import UIKit

extension UIView {
  func applyShadow() {
    self.layer.cornerRadius = 8
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    self.layer.shadowOpacity = 0.3
    self.layer.masksToBounds = false
  }
}
