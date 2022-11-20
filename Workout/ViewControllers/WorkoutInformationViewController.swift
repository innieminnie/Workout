//
//  WorkoutInformationViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/10/25.
//

import UIKit

protocol UpdateWorkoutDelegate: AnyObject {
  func saveNewWorkout(workout: Workout)
  func updateWorkout(code: String, name: String, bodySection: BodySection)
}

class WorkoutInformationViewController: UIViewController {
  let workoutSettingView = WorkoutSettingView()
  weak var updateWorkoutDelegate: UpdateWorkoutDelegate?
  private var handlingWorkoutCode: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    workoutSettingView.delegate = self
    
    view.addSubview(workoutSettingView)
    self.view.backgroundColor = .clear
    
    NSLayoutConstraint.activate([
      workoutSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      workoutSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      workoutSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
    ])
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    workoutSettingView.setFirstResponder()
  }
  
  @objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }

    let keyboardHeight = keyboardFrame.height
    let workoutViewHeight = workoutSettingView.frame.height
    
    if view.frame.height - keyboardHeight < workoutSettingView.frame.origin.y + workoutViewHeight {
      workoutSettingView.frame.origin.y -= keyboardHeight
    }
    
    workoutSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = false
    workoutSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(keyboardHeight + 10)).isActive = true
    
  }

  @objc private func keyboardWillHide(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }

    let keyboardHeight = keyboardFrame.height
    workoutSettingView.frame.origin.y += keyboardHeight
    
    workoutSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
    workoutSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(keyboardHeight + 10)).isActive = false
  }
}
extension WorkoutInformationViewController: SendingWorkoutDelegate {
  func showInformation(of workout: Workout) {
    self.handlingWorkoutCode = workout.id
    workoutSettingView.setUp(with: workout)
  }
}
extension WorkoutInformationViewController: UpdateWorkoutActionDelegate {
  
  func tappedCancel() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func register(_ name: String, _ bodySection: BodySection) {
    if let workoutCode = handlingWorkoutCode {
      self.updateWorkoutDelegate?.updateWorkout(code: workoutCode, name: name, bodySection: bodySection)
    } else {
      self.updateWorkoutDelegate?.saveNewWorkout(workout: Workout(name, bodySection))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func resignFirstResponder(on textField: UITextField) {
    textField.resignFirstResponder()
  }
}
extension WorkoutInformationViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
