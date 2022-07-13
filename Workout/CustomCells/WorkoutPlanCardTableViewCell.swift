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
  func textFieldsAreNotFilled()
}

enum WorkoutStatus {
  case doing
  case done
  
  var buttonTitle: String {
    switch self {
    case .doing:
      return "운동완료"
    case .done:
      return "기록수정"
    }
  }
}

class WorkoutPlanCardTableViewCell: UITableViewCell {
  static let identifier = "workoutPlanCardTableViewCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var workoutNameLabel: UILabel!
  @IBOutlet weak var setSumLabel: UILabel!
  @IBOutlet weak var setStackView: UIStackView!
  @IBOutlet weak var plusSetButton: UIButton!
  @IBOutlet weak var minusSetButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  weak var delegate: WorkoutPlanCardTableViewCellDelegate?
  private var currentWorkout: PlannedWorkout?
  private var totalSum: Int = 0 {
    didSet {
      setSumLabel.text = "\(totalSum)"
    }
  }
  
  private var workoutStatus: WorkoutStatus =
    .doing {
      didSet {
        doneButton.setTitle(workoutStatus.buttonTitle, for: .normal)
      }
    }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    containerView.applyShadow()
    setStackView.translatesAutoresizingMaskIntoConstraints = false
    
    setSumLabel.text = "\(totalSum)"
    doneButton.isEnabled = false
    doneButton.addTarget(self, action: #selector(tappedDoneButton(sender:)), for: .touchUpInside)
    plusSetButton.addTarget(self, action: #selector(tappedPlusSetButton(sender:)), for: .touchUpInside)
    minusSetButton.addTarget(self, action: #selector(tappedMinusSetButton(sender:)), for: .touchUpInside)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
  }
  
  override func prepareForReuse() {
    while !setStackView.arrangedSubviews.isEmpty {
      guard let lastSet = setStackView.arrangedSubviews.last else {
        return
      }
      
      setStackView.removeArrangedSubview(lastSet)
      if setStackView.arrangedSubviews.isEmpty { doneButton.isEnabled = false }
      lastSet.removeFromSuperview()
      delegate?.cellShrink()
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setUp(with plannedWorkout: PlannedWorkout) {
    self.currentWorkout = plannedWorkout
    
    let workout = plannedWorkout.workout
    let sets = plannedWorkout.sets.sorted { set1, set2 in
      set1.key < set2.key
    }
    
    workoutNameLabel.text = workout.name
    
    if !sets.isEmpty {
      for singleSet in sets {
        let setConfigurationView = WorkoutSetConfigurationView(index: singleSet.key, setInformation: singleSet.value)
        setStackView.addArrangedSubview(setConfigurationView)
        if !doneButton.isEnabled { doneButton.isEnabled = true }
        setConfigurationView.delegate = self
        delegate?.cellExpand()
      }
    }
  }
  
  @objc func tappedDoneButton(sender: UIButton) {
    switch workoutStatus {
    case .doing:
      for workoutSetView in setStackView.arrangedSubviews {
        guard let singleSetView = workoutSetView as? WorkoutSetConfigurationView else {
          return
        }
        
        guard singleSetView.allFieldsAreWritten() else {
          delegate?.textFieldsAreNotFilled()
          return
        }
      }
      
      for workoutSetView in setStackView.arrangedSubviews {
        guard let singleSetView = workoutSetView as? WorkoutSetConfigurationView else {
          return
        }
        
        singleSetView.showDoneStatusView()
        workoutStatus = .done
        
      }
    case .done:
      for workoutSetView in setStackView.arrangedSubviews {
        guard let singleSetView = workoutSetView as? WorkoutSetConfigurationView else {
          continue
        }
        
        singleSetView.showDoingStatusView()
      }
      
      workoutStatus = .doing
    }
  }
  
  @objc func tappedPlusSetButton(sender: UIButton) {
    let setConfigurationView = WorkoutSetConfigurationView(index: setStackView.arrangedSubviews.count + 1, setInformation: SetConfiguration())
    setStackView.addArrangedSubview(setConfigurationView)
    if !doneButton.isEnabled { doneButton.isEnabled = true }
    setConfigurationView.delegate = self
    delegate?.cellExpand()
  }
  
  @objc func tappedMinusSetButton(sender: UIButton) {
    guard let lastSet = setStackView.arrangedSubviews.last else {
      return
    }
    
    setStackView.removeArrangedSubview(lastSet)
    if setStackView.arrangedSubviews.isEmpty { doneButton.isEnabled = false }
    lastSet.removeFromSuperview()
    delegate?.cellShrink()
  }
}
extension WorkoutPlanCardTableViewCell: WorkoutSetConfigurationViewDelegate {
  func weightValueUpdated(to newValue: Int, of index: Int) {
    guard let currentWorkout = self.currentWorkout else {
      return
    }
    
    currentWorkout.updateWeight(of: index, to: newValue )
  }
  
  func countValueUpdated(to newValue: Int, of index: Int) {
    guard let currentWorkout = self.currentWorkout else {
      return
    }
    
    currentWorkout.updateCount(of: index, to: newValue )
  }
  
  func setSumUpdated(from oldValue: Int, to newValue: Int) {
    totalSum += (newValue - oldValue)
  }
}

