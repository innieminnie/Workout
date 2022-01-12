//
//  WorkoutTableViewCell.swift
//  Workout
//
//  Created by 강인희 on 2021/12/08.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    static let identifier = "workoutTableViewCell"
  
  @IBOutlet weak var workoutCellBackgroundView: UIView!
  @IBOutlet weak var workoutNameLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    NSLayoutConstraint.activate([
      workoutCellBackgroundView.heightAnchor.constraint(equalTo: workoutNameLabel.heightAnchor, multiplier: 3.0)
    ])
    workoutCellBackgroundView.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setUp(with workout: Workout) {
    workoutNameLabel.text = workout.name
  }
    
}
