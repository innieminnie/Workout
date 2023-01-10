//
//  RecordTableViewCell.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/10.
//

import UIKit

class RecordView: UIView {
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textColor = .black
    label.font = .Pretendard(type: .Semibold, size: 18)
    label.textAlignment = .left
    label.numberOfLines = 0
    
    return label
  }()
  
  private let setStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .equalSpacing
    
    return stackView
  }()
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  convenience init(name: String, weightUnit: WeightUnit, sets: [SetConfiguration]) {
    self.init()
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(nameLabel)
    nameLabel.text = name
    
    for setData in sets {
      let label = PaddingLabel()
      label.text = "\(setData.displayWeight) \(weightUnit.rawValue)  \(setData.displayCount) reps"
      label.font = UIFont.Pretendard(type: .Regular, size: 15)
      setStackView.addArrangedSubview(label)
    }
    self.addSubview(setStackView)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      setStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      setStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 30),
      setStackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
      setStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -5)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class RecordTableViewCell: UITableViewCell {
  static let identifier = "recordTableViewCell"
  
  @IBOutlet weak var recordsStackView: UIStackView!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setUp(with workoutData: [PlannedWorkout]) {
    for plan in workoutData {
      guard let workout = workoutManager.workoutByCode(plan.workoutCode) else { continue }
      
      recordsStackView.addArrangedSubview(RecordView(name: workout.displayName(), weightUnit: workout.weightUnit, sets: plan.sets))
    }
  }
}
