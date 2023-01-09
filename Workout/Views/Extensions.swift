//
//  Extensions.swift
//  Workout
//
//  Created by 강인희 on 2022/06/30.
//

import UIKit

extension Int {
  func convertToRGB() -> UIColor {
    return UIColor(
        red: CGFloat((Float((self & 0xff0000) >> 16)) / 255.0),
        green: CGFloat((Float((self & 0x00ff00) >> 8)) / 255.0),
        blue: CGFloat((Float((self & 0x0000ff) >> 0)) / 255.0),
        alpha: 1.0)
  }
}
extension Date {
  func changeToDateComponents() -> DateComponents {
    let year = Calendar.current.component(.year, from: self)
    let month = Calendar.current.component(.month, from: self)
    let day = Calendar.current.component(.day, from: self)
    
    return DateComponents(year: year, month: month, day: day)
  }
}
extension UIView {
  func applyCornerRadius(_ cornerRadius: CGFloat) {
    self.layer.cornerRadius = cornerRadius
    self.layer.masksToBounds = true
  }
  
  func applyShadow() {
    self.layer.shadowColor = 0xBEC0C2.convertToRGB().cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 10
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.masksToBounds = false
  }
}
extension UIButton {
  func configureDisableMode(title: String) {
    self.isEnabled = false
    self.customizeConfiguration(with: title, foregroundColor: .white, font: UIFont.Pretendard(type: .Bold, size: 20), buttonSize: .medium)
    self.backgroundColor = 0xBEC0C2.convertToRGB()
  }
  
  func configureAbleMode(title: String) {
    self.isEnabled = true
    self.customizeConfiguration(with: title, foregroundColor: .white, font: UIFont.Pretendard(type: .Semibold, size: 15), buttonSize: .medium)
    self.backgroundColor = 0x096DB6.convertToRGB()
  }
  
  func customizeConfiguration(with title: String, foregroundColor: UIColor, font: UIFont, buttonSize: UIButton.Configuration.Size ) {
    self.configurationUpdateHandler = { [unowned self] button in
      var customizeConfiguration = UIButton.Configuration.plain()
      customizeConfiguration.title = title
      customizeConfiguration.titleAlignment = .center
      customizeConfiguration.attributedTitle?.font = font
      customizeConfiguration.baseForegroundColor = foregroundColor
      customizeConfiguration.buttonSize = buttonSize
      customizeConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
      
      self.configuration = customizeConfiguration
    }
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
extension UIFont {
  class func Pretendard(type: PretendardType, size: CGFloat) -> UIFont! {
    guard let font = UIFont(name: type.name, size: size) else {
      return nil
    }
    return font
  }

  public enum PretendardType {
    case Bold
    case ExtraBold
    case ExtraLight
    case Light
    case Medium
    case Regular
    case Semibold
    case Thin

    var name: String {
      switch self {
      case .Bold:
        return "Pretendard-Bold"
      case .ExtraBold:
        return "Pretendard-ExtraBold"
      case .ExtraLight:
        return "Pretendard-ExtraLight"
      case .Light:
        return "Pretendard-Light"
      case .Medium:
        return "Pretendard-Medium"
      case .Regular:
        return "Pretendard-Regular"
      case .Semibold:
        return "Pretendard-SemiBold"
      case .Thin:
        return "Pretendard-Thin"
      }
    }
  }
}
extension UIScrollView {
   func scrollToBottom() {
     if self.contentSize.height < self.bounds.size.height { return }
     
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height)
     UIView.animate(withDuration: 2) {
       self.setContentOffset(bottomOffset, animated: false)
     }
  }
}
