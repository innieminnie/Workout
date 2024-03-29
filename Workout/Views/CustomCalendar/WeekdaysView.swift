//
//  WeekdaysView.swift
//  Workout
//
//  Created by 강인희 on 2022/06/30.
//

import UIKit

class WeekdaysView: UIView {
  private let weekdays = Weekday.weekdaysName
  
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
  
    self.backgroundColor = 0xF58423.convertToRGB()
    
    for dayName in weekdays {
      let weekdayLabel = UILabel()
      weekdayLabel.text = dayName
      weekdayLabel.textColor = .white
      weekdayLabel.textAlignment = .center
      weekdayLabel.font = UIFont.Pretendard(type: .Medium, size: 15)
      containerStackView.addArrangedSubview(weekdayLabel)
    }
    
    self.addSubview(containerStackView)
    
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
