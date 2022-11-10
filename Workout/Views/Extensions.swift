//
//  Extensions.swift
//  Workout
//
//  Created by 강인희 on 2022/06/30.
//

import UIKit

extension UIView {
  func applyCornerRadius() {
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
  }
  
  func applyShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = 5
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.masksToBounds = false
  }
}
extension UIButton {
  func customizeConfiguration(with title: String) {
    var customizeConfiguration = UIButton.Configuration.plain()
    customizeConfiguration.title = title
    customizeConfiguration.titleAlignment = .center
    customizeConfiguration.baseForegroundColor = .black
    customizeConfiguration.buttonSize = .medium
    customizeConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
    
    self.configuration = customizeConfiguration
  }
}
