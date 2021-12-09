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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(with workout: Workout) {
    workoutNameLabel.text = workout.name
  }
    
}
