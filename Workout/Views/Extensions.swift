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
    self.layer.shadowColor = 0xBEC0C2.converToRGB().cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 3
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.masksToBounds = false
  }
}
extension UIButton {
  func customizeConfiguration(with title: String, foregroundColor: UIColor) {
    var customizeConfiguration = UIButton.Configuration.plain()
    customizeConfiguration.title = title
    customizeConfiguration.titleAlignment = .center
    customizeConfiguration.attributedTitle?.font = UIFont.boldSystemFont(ofSize: 20)
    customizeConfiguration.baseForegroundColor = foregroundColor
    customizeConfiguration.buttonSize = .medium
    customizeConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
    
    self.configuration = customizeConfiguration
  }
}
extension UIViewController {
  func showSignInViewController() {
    let signInViewController = SignInViewController()
    signInViewController.modalPresentationStyle = .formSheet
    signInViewController.isModalInPresentation = true
    self.present(signInViewController, animated: false, completion: nil)
  }
}
extension Int {
  func converToRGB() -> UIColor {
    return UIColor(
        red: CGFloat((Float((self & 0xff0000) >> 16)) / 255.0),
        green: CGFloat((Float((self & 0x00ff00) >> 8)) / 255.0),
        blue: CGFloat((Float((self & 0x0000ff) >> 0)) / 255.0),
        alpha: 1.0)
  }
}
