//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class WorkoutListViewController: UIViewController {
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
    
    workoutListTableView.dataSource = self
    workoutListTableView.delegate = self
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    workoutListTableView.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
    view.addSubview(workoutListTableView)
    
    setUpLayout()
    
  }
  
  private func setUpNavigationController() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.topItem?.title = "나의 운동 목록"
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      workoutListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      workoutListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      workoutListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      workoutListTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
      
      addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
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
extension WorkoutListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workoutManager.numberOfWorkoutList()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workoutManager.workout(at: indexPath.row)
  
    cell.configure(with: workout)
    
    return cell
  }
}
extension WorkoutListViewController: UITableViewDelegate {
  
}
