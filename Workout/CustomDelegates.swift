//
//  CustomDelegates.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import Foundation
import UIKit

protocol CalendarViewDelegate: AnyObject {
  func changedSelectedDay(to dateInformation: DateInformation?)
  func calendarIsFolded(height: CGFloat)
  func calendarIsOpened()
}

protocol UpdateWorkoutActionDelegate: AnyObject {
  func tappedCancel()
  func register(_ name: String, _ weightUnit: WeightUnit, _ bodySection: BodySection)
  func resignFirstResponder(on textField: UITextField)
}

protocol WorkoutSetConfigurationViewDelegate: AnyObject {
  func setSumUpdated(from oldValue: Float, to newValue: Float)
  func weightValueUpdated(to newValue: Float, of index: Int)
  func countValueUpdated(to newValue: UInt, of index: Int)
}

protocol SendingWorkoutDelegate: AnyObject {
  func showInformation(of workout: Workout)
}

protocol WorkoutSelectionDelegate: AnyObject {
  func addSelectedWorkouts(_ selectedWorkouts: [Workout])
  func copyPlannedWorkouts(from date: DateInformation)
}

protocol UpdateWorkoutDelegate: AnyObject {
  func saveNewWorkout(workout: Workout)
  func updateWorkout(code: String, name: String, weightUnit: WeightUnit, bodySection: BodySection)
}

protocol WorkoutPlanCardTableViewCellDelegate: AnyObject {
  func cellExpand()
  func cellShrink()
  func textFieldsAreNotFilled()
  func currentDateInformation() -> DateInformation?
}
