//
//  WorkoutPlanCardTableViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/05/12.
//

import UIKit
protocol WorkoutPlanCardTableViewCellDelegate: AnyObject {
  func cellExpand()
  func cellShrink()
}

class WorkoutPlanCardTableViewCell: UITableViewCell {
  static let identifier = "workoutPlanCardTableViewCell"
  @IBOutlet weak var workoutNameLabel: UILabel!
  @IBOutlet weak var setStackView: UIStackView!
  @IBOutlet weak var plusSetButton: UIButton!
  @IBOutlet weak var minusSetButton: UIButton!
  weak var delegate: WorkoutPlanCardTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layer.cornerRadius = 13
  
    setStackView.translatesAutoresizingMaskIntoConstraints = false
    setStackView.isHidden = true
    plusSetButton.addTarget(self, action: #selector(tappedPlusSetButton(sender:)), for: .touchUpInside)
    minusSetButton.addTarget(self, action: #selector(tappedMinusSetButton(sender:)), for: .touchUpInside)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setUp(with workout: Workout) {
    workoutNameLabel.text = workout.name
  }
  
  @objc func tappedPlusSetButton(sender: UIButton) {
    let setConfigurationView = WorkoutSetConfigurationView()
    setStackView.addArrangedSubview(setConfigurationView)
    if setStackView.isHidden { setStackView.isHidden = false }
    delegate?.cellExpand()
  }
  
  @objc func tappedMinusSetButton(sender: UIButton) {
    guard let lastSet = setStackView.arrangedSubviews.last else {
      setStackView.isHidden = true
      return
    }
    
    setStackView.removeArrangedSubview(lastSet)
    lastSet.removeFromSuperview()
    delegate?.cellShrink()
  }
}
