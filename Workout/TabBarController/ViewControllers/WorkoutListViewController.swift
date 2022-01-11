//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class WorkoutListViewController: UITableViewController {
  private let addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.backgroundColor = .systemPurple
    button.setTitle("+", for: .normal)
    button.setTitleColor(.white, for: .normal)
    
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOpacity = 1.0
    button.layer.shadowOffset = .zero
    button.layer.shadowRadius = 6
    
    button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchDown)
    button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchDragEnter)
    button.addTarget(self, action: #selector(buttonUntouched(_:)), for: .touchDragOutside)
    button.addTarget(self, action: #selector(tappedAddNewWorkout(_:)), for: .touchUpInside)
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpNavigationController()
    setUpSearchController()
    setUpListTableView()
    view.addSubview(addButton)
    setUpLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let footerViewHeight = addButton.frame.size.height * 1.5
    guard let footerView = tableView.tableFooterView else {
      return
    }

    if footerView.frame.size.height != footerViewHeight {
      footerView.frame.size.height = footerViewHeight
    }
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
}
extension WorkoutListViewController: TabBarMenu {
  var tabTitle: String {
    "목록"
  }
  
  var icon: String {
    "list.bullet"
  }
}
extension WorkoutListViewController: AddNewWorkoutDelegate {
  func saveNewWorkout(workout: Workout) {
    workoutManager.register(workout: workout)
    tableView.reloadData()
  }
}
extension WorkoutListViewController {
  @objc private func buttonTouched(_ sender: UIButton) {
    sender.alpha = 0.8
  }
  
  @objc private func buttonUntouched(_ sender: UIButton) {
    sender.alpha = 1
  }
  
  @objc private func tappedAddNewWorkout(_ sender: UIButton) {
    let newWorkoutViewController = NewWorkoutViewController()
    newWorkoutViewController.delegate = self
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.present(newWorkoutViewController, animated: true) {
        sender.alpha = 1
      }
    }
  }
  
  private func setUpNavigationController() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.topItem?.title = "나의 운동 목록"
  }
  
  private func setUpSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    self.navigationItem.searchController = searchController
  }
  
  private func setUpListTableView() {
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
    tableView.tableFooterView = UIView()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      addButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
      addButton.heightAnchor.constraint(equalTo:addButton.widthAnchor)
    ])
    
    addButton.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.1
  }
}
