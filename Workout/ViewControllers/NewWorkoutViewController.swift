//
//  NewWorkOutViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/30.
//

import Foundation
import UIKit

protocol AddNewWorkoutDelegate: AnyObject {
  func saveNewWorkout(workout: Workout)
}

class NewWorkoutViewController: UIViewController {
  let newWorkoutView = NewWorkoutView()
  weak var delegate: AddNewWorkoutDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    newWorkoutView.delegate = self
    
    view.addSubview(newWorkoutView)
    view.backgroundColor = .white
    
    NSLayoutConstraint.activate([
      newWorkoutView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      newWorkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      newWorkoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      newWorkoutView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
extension NewWorkoutViewController: UpdateWorkoutActionDelegate {
  func tappedCancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func register(_ name: String, _ bodySection: BodySection) {
    self.delegate?.saveNewWorkout(workout: Workout(name, bodySection))
    self.dismiss(animated: true, completion: nil)
  }
}

