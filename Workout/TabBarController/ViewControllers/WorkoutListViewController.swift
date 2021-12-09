//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class WorkoutListViewController: UITableViewController {
  private lazy var addButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("새로운 운동 추가", for: .normal)
    button.backgroundColor = .systemPurple
    button.layer.cornerRadius = 13.0
    button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchDown)
    button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchDragEnter)
    button.addTarget(self, action: #selector(buttonUntouched(_:)), for: .touchDragOutside)
    button.addTarget(self, action: #selector(tappedAddNewWorkout(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var workoutListTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(addButton)
    setUpNavigationController()
    setUpListTableView()
    setUpLayout()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workoutManager.numberOfWorkoutList()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workoutManager.workout(at: indexPath.row)
    cell.setUp(with: workout)
    
    return cell
  }
  
  private func setUpNavigationController() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.topItem?.title = "나의 운동 목록"
  }

  private func setUpListTableView() {
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      addButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
      addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
    ])
  }
  
  @objc private func buttonTouched(_ sender: UIButton) {
    sender.alpha = 0.8
  }
  
  @objc private func buttonUntouched(_ sender: UIButton) {
    sender.alpha = 1
  }
  
  @objc private func tappedAddNewWorkout(_ sender: UIButton) {
    let newWorkoutViewController = NewWorkoutViewController()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.present(newWorkoutViewController, animated: true) {
        sender.alpha = 1
      }
    }
  }
}
extension WorkoutListViewController: TabBarMenu {
  var tabTitle: String {
    "목록"
  }
  
  var icon: String {
    "list.bullet"
  }
}
