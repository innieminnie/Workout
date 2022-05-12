//
//  WorkoutTableViewCell.swift
//  Workout
//
//  Created by 강인희 on 2021/12/08.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
  static let identifier = "workoutTableViewCell"
  @IBOutlet weak var workoutNameLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layer.cornerRadius = 13
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
    
    func setUp(with workout: Workout) {
      workoutNameLabel.text = workout.name
  }
  
}
