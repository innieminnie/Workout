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
  func currentDateInformation() -> DateInformation?
}

class WorkoutPlanCardTableViewCell: UITableViewCell {
  static let identifier = "workoutPlanCardTableViewCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var workoutNameLabel: PaddingLabel!
  @IBOutlet weak var setSumLabel: PaddingLabel!
  @IBOutlet weak var setStackView: UIStackView!
  @IBOutlet weak var setButtonStackView: UIStackView!
  @IBOutlet weak var plusSetButton: UIButton!
  @IBOutlet weak var minusSetButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  weak var delegate: WorkoutPlanCardTableViewCellDelegate?
  private var currentWorkout: PlannedWorkout?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    containerView.applyCornerRadius()
    contentView.applyShadow()
    
    setStackView.translatesAutoresizingMaskIntoConstraints = false
    
    setSumLabel.text = String(format: "%0.3f", currentWorkout?.totalSum ?? 0.0)
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
    let sets = plannedWorkout.sets
    
    workoutNameLabel.text = plannedWorkout.checkWorkoutName()
    doneButton.setTitle(plannedWorkout.isDone.buttonTitle, for: .normal)
    setButtonStackView.isHidden = plannedWorkout.isDone.rawValue
    
    if !sets.isEmpty {
      if !doneButton.isEnabled { doneButton.isEnabled = true }
      
      for (idx, singleSet) in sets.enumerated() {
        let setConfigurationView = WorkoutSetConfigurationView(index: idx, setInformation: singleSet)
        setStackView.addArrangedSubview(setConfigurationView)
        setConfigurationView.delegate = self
        delegate?.cellExpand()
        
        if plannedWorkout.isDone == .done {
          setConfigurationView.showDoneStatusView()
        }
      }
    }
    
    setSumLabel.text = String(format: "%0.3f", currentWorkout?.totalSum ?? 0.0)
  }
  
  @objc func tappedDoneButton(sender: UIButton) {
    guard let currentWorkout = self.currentWorkout else { return }
    
    switch currentWorkout.isDone {
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
      }
      
      currentWorkout.isDone = .done
    case .done:
      for workoutSetView in setStackView.arrangedSubviews {
        guard let singleSetView = workoutSetView as? WorkoutSetConfigurationView else {
          continue
        }
        
        singleSetView.showDoingStatusView()
      }
      
      currentWorkout.isDone = .doing
    }
    
    guard let currentDateInformation = delegate?.currentDateInformation() else { return }
    routineManager.updateRoutine(workout: currentWorkout, on: currentDateInformation)
    doneButton.setTitle(currentWorkout.isDone.buttonTitle, for: .normal)
    setButtonStackView.isHidden = currentWorkout.isDone.rawValue
  }
  
  @objc func tappedPlusSetButton(sender: UIButton) {
    guard let currentWorkout = self.currentWorkout else {
      return
    }
    
    let newSetIndex = currentWorkout.sets.count
    let newSetConfiguration = newSetIndex > 0 ? currentWorkout.sets[currentWorkout.sets.count - 1] : SetConfiguration()
    let setConfigurationView = WorkoutSetConfigurationView(index: newSetIndex, setInformation: newSetConfiguration)
    setStackView.addArrangedSubview(setConfigurationView)
    if !doneButton.isEnabled { doneButton.isEnabled = true }
    setConfigurationView.delegate = self
    delegate?.cellExpand()
    
    currentWorkout.addNewSet(with: newSetConfiguration)
    setSumLabel.text = String(format: "%0.3f", currentWorkout.totalSum)
    guard let currentDateInformation = delegate?.currentDateInformation() else { return }
    routineManager.updateRoutine(workout: currentWorkout, on: currentDateInformation)
  }
  
  @objc func tappedMinusSetButton(sender: UIButton) {
    guard let currentWorkout = self.currentWorkout, let lastSet = setStackView.arrangedSubviews.last as? WorkoutSetConfigurationView else {
      return
    }
    
    lastSet.resetWeightAndCountValues()
    currentWorkout.removeSet(of: setStackView.arrangedSubviews.count - 1)
    guard let currentDateInformation = delegate?.currentDateInformation() else { return }
    routineManager.updateRoutine(workout: currentWorkout, on: currentDateInformation)
    
    setStackView.removeArrangedSubview(lastSet)
    if setStackView.arrangedSubviews.isEmpty { doneButton.isEnabled = false }
    lastSet.removeFromSuperview()
    delegate?.cellShrink()
  }
}
extension WorkoutPlanCardTableViewCell: WorkoutSetConfigurationViewDelegate {
  func weightValueUpdated(to newValue: Float, of index: Int) {
    guard let currentWorkout = self.currentWorkout else {
      return
    }
    
    currentWorkout.updateWeight(of: index, to: newValue )
    
    guard let currentDateInformation = delegate?.currentDateInformation() else { return }
    routineManager.updateRoutine(workout: currentWorkout, on: currentDateInformation)
  }
  
  func countValueUpdated(to newValue: UInt, of index: Int) {
    guard let currentWorkout = self.currentWorkout else {
      return
    }
    
    currentWorkout.updateCount(of: index, to: newValue )
    
    guard let currentDateInformation = delegate?.currentDateInformation() else { return }
    routineManager.updateRoutine(workout: currentWorkout, on: currentDateInformation)
  }
  
  func setSumUpdated(from oldValue: Float, to newValue: Float) {
    setSumLabel.text = String(format: "%0.3f", currentWorkout?.totalSum ?? 0.0)
  }
}

