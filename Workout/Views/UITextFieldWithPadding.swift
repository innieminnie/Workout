//
//  UITextFieldWithPadding.swift
//  pitapatpumping
//
//  Created by 강인희 on 2022/12/22.
//

import UIKit

class UITextFieldWithPadding: UITextField {
  var textPadding = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
}
