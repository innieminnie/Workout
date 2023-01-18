//
//  RoundedCornerView.swift
//  Workout
//
//  Created by 강인희 on 2021/12/02.
//

import Foundation
import UIKit

class RoundedCornerLabelView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Regular, size: 15)
    
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.applyCornerRadius(8)
    self.backgroundColor = .white
  }
  
  convenience init(title: String) {
    self.init()
    
    self.titleLabel.text = title
    self.titleLabel.textColor = .black
    self.layer.borderColor = 0xF58423.convertToRGB().withAlphaComponent(0.3).cgColor
    self.layer.borderWidth = 2
    
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
      titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func changeToSelectedBackgroundColor() {
    self.backgroundColor = 0xF58423.convertToRGB()
  }
  
  func changeToDeselectedBackgroundColor() {
    self.backgroundColor = .white
  }
}

class RoundedCornerTextFieldView: UIView {
  let valueTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.textAlignment = .right
    textField.font = UIFont.Pretendard(type: .Regular, size: 15)
    
    return textField
  }()
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(valueTextField)
    self.applyCornerRadius(8)
    self.backgroundColor = 0xBEC0C2.convertToRGB()
  }
  
  convenience init(value: String) {
    self.init()
    
    self.valueTextField.text = value
    self.valueTextField.textColor = .black
    
    NSLayoutConstraint.activate([
      valueTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      valueTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      valueTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      valueTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
