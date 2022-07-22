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
    
    tableView.allowsMultipleSelection = true
    return tableView
  }()
  
  private let addRoutineButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitle("선택한 운동 추가하기", for: .normal)
    button.layer.cornerRadius = 13
    button.addTarget(self, action: #selector(tappedAddRoutineButton(sender:)), for: .touchUpInside)
    button.isEnabled = false
    button.backgroundColor = .systemGray
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(workoutListTableView)
    view.addSubview(addRoutineButton)
    setUpListTableView()
    setUpLayout()
  }

  @objc func tappedAddRoutineButton(sender: UIButton) {
    if let selectedWorkoutIndexPaths = self.workoutListTableView.indexPathsForSelectedRows {
      self.selectedWorkouts = selectedWorkoutIndexPaths.map({ indexPath in
        workoutManager.workout(at: indexPath.row)
      })
    }
  
    self.delegate?.addSelectedWorkouts(self.selectedWorkouts)
    self.dismiss(animated: true, completion: nil)
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      workoutListTableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 20),
      workoutListTableView.leadingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      workoutListTableView.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      
      addRoutineButton.topAnchor.constraint(equalTo: workoutListTableView.bottomAnchor, constant: 10),
      addRoutineButton.leadingAnchor.constraint(equalTo: workoutListTableView.leadingAnchor),
      addRoutineButton.trailingAnchor.constraint(equalTo: workoutListTableView.trailingAnchor),
      addRoutineButton.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
    guard addRoutineButton.isEnabled else {
      addRoutineButton.isEnabled = true
      addRoutineButton.backgroundColor = .purple
      return
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard tableView.indexPathsForSelectedRows != nil else {
      addRoutineButton.isEnabled = false
      addRoutineButton.backgroundColor = .systemGray
      return
    }
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
