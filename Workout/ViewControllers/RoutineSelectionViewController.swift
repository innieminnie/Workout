//
//  RoutineSelectionViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/04/20.
//

import UIKit

protocol RoutineSelectionDelegate: AnyObject {
  func addSelectedWorkouts(_ selectedWorkouts: [Workout])
}
class RoutineSelectionViewController: UIViewController {
  private var selectedWorkouts = [Workout]()
  weak var delegate: RoutineSelectionDelegate?
  
  private let workoutListTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(workoutListTableView)
    setUpListTableView()
    setUpLayout()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.delegate?.addSelectedWorkouts(selectedWorkouts)
  }
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      workoutListTableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 20),
      workoutListTableView.leadingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      workoutListTableView.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      workoutListTableView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
}
extension RoutineSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workoutManager.numberOfWorkoutList()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workoutManager.workout(at: indexPath.row)
    cell.setUp(with: workout)
    
    return cell
  }
}
extension RoutineSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedWorkout = workoutManager.workout(at: indexPath.row)
    selectedWorkouts.append(selectedWorkout)
  }
}
extension RoutineSelectionViewController {
  private func setUpListTableView() {
    workoutListTableView.dataSource = self
    workoutListTableView.delegate = self
    
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    self.workoutListTableView.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
    self.workoutListTableView.separatorStyle = .none
  }
}
