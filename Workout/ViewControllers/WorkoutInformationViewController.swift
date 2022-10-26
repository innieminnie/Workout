//
//  WorkoutInformationViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/10/25.
//

import UIKit

protocol UpdateWorkoutDelegate: AnyObject {
  func updateWorkout(code: String, name: String, bodySection: BodySection)
}

class WorkoutInformationViewController: UIViewController {
  let updateWorkoutView = NewWorkoutView()
  weak var delegate: UpdateWorkoutDelegate?
  private var handlingWorkoutCode: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateWorkoutView.delegate = self
    
    view.addSubview(updateWorkoutView)
    self.view.backgroundColor = .white
    
    NSLayoutConstraint.activate([
      updateWorkoutView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      updateWorkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      updateWorkoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      updateWorkoutView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
extension WorkoutInformationViewController: SendingWorkoutDelegate {
  func showInformation(of workout: Workout) {
    self.handlingWorkoutCode = workout.id
    updateWorkoutView.setUp(with: workout)
  }
}
extension WorkoutInformationViewController: UpdateWorkoutActionDelegate {
  func tappedCancel() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func register(_ name: String, _ bodySection: BodySection) {
    if let workoutCode = handlingWorkoutCode {
      self.delegate?.updateWorkout(code: workoutCode, name: name, bodySection: bodySection)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
}
