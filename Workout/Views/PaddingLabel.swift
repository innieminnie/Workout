//
//  PaddingLabel.swift
//  Workout
//
//  Created by 강인희 on 2022/11/01.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
  @IBInspectable var topInset: CGFloat = 5.0
  @IBInspectable var bottomInset: CGFloat = 5.0
  @IBInspectable var leftInset: CGFloat = 5.0
  @IBInspectable var rightInset: CGFloat = 5.0
  
  override func drawText(in rect: CGRect) {
    let padding = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: padding))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
  }
}
