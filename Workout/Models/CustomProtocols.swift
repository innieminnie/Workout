//
//  CustomProtocols.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol CalendarViewDelegate: AnyObject {
  func changedSelectedDay(to dateInformation: DateInformation?)
  func calendarIsFolded(height: CGFloat)
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

protocol ContainWorkoutList {
  var workoutListDataSource: WorkoutListDataSource { get }
}
extension ContainWorkoutList {
    var workoutListDataSource: WorkoutListDataSource {
      return WorkoutListDataSource.shared
    }
}

protocol NetworkAccessible {
  var encoder: JSONEncoder { get }
  var decoder: JSONDecoder { get }
  var ref: DatabaseReference! { get }
  var uid: String { get }
}
extension NetworkAccessible {
  var encoder: JSONEncoder {
    return NetworkServiceInformation.encoder
  }
  var decoder: JSONDecoder {
    return NetworkServiceInformation.decoder
  }
  var ref: DatabaseReference! {
    return NetworkServiceInformation.ref
  }
  var uid: String {
    return NetworkServiceInformation.uid
  }
}
