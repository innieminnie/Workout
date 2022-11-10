//
//  WorkoutTableViewCell.swift
//  Workout
//
//  Created by 강인희 on 2021/12/08.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
  static let identifier = "workoutTableViewCell"
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var workoutNameLabel: PaddingLabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    containerView.applyCornerRadius()
    contentView.applyShadow()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
    
    func setUp(with workout: Workout) {
      workoutNameLabel.text = workout.displayName()
  }
  
}
