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
    
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.layer.cornerRadius = 13
    self.layer.borderWidth = 1
    self.backgroundColor = .white
  }
  
  convenience init(title: String) {
    self.init()
    
    self.titleLabel.text = title
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
    ])
    
    self.layoutSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
