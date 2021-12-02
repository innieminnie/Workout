//
//  NewWorkOutViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/30.
//

import Foundation
import UIKit

class NewWorkoutViewController: UIViewController {
  let newWorkoutView = NewWorkoutView()
  
  override func viewDidLoad() {
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
