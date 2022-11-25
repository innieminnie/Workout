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
  
  private lazy var addRoutineButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.customizeConfiguration(with: "선택한 운동을 추가할게요", foregroundColor: .white, font: UIFont.boldSystemFont(ofSize: 20), buttonSize: .medium)
    button.backgroundColor = 0xBEC0C2.convertToRGB()
    button.applyCornerRadius(24)
    button.addTarget(self, action: #selector(tappedAddRoutineButton(sender:)), for: .touchUpInside)
    button.isEnabled = false
    
    return button
  }()
  
  private lazy  var noticeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let notice = "등록된 운동이 없어요.\n\"목록\"에서 운동 종목을 추가해보세요!"
    label.text = notice
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    if workoutManager.totalWorkoutsCount() == 0 {
      view.addSubview(noticeLabel)
      setUpNoticeLabel()
    } else {
      view.addSubview(workoutListTableView)
      view.addSubview(addRoutineButton)
      setUpListTableView()
      setUpLayout()
    }
  }

  @objc func tappedAddRoutineButton(sender: UIButton) {
    if let selectedWorkoutIndexPaths = self.workoutListTableView.indexPathsForSelectedRows {
      self.selectedWorkouts = selectedWorkoutIndexPaths.map({ indexPath in
        workoutManager.workout(at: indexPath)
      })
    }
  
    self.delegate?.addSelectedWorkouts(self.selectedWorkouts)
    self.dismiss(animated: true, completion: nil)
  }
  
  private func setUpNoticeLabel() {
    NSLayoutConstraint.activate([
      noticeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      noticeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      noticeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      noticeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ])
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
  func numberOfSections(in tableView: UITableView) -> Int {
    BodySection.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let bodySection = BodySection.allCases[section]
    return workoutManager.filteredWorkout(by: bodySection).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workoutManager.workout(at: indexPath)
    cell.setUp(with: workout)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let bodySection = BodySection.allCases[section]
    return workoutManager.filteredWorkout(by: bodySection).count == 0 ? nil : BodySection.allCases[section].rawValue
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = 0x096DB6.convertToRGB()
  }
}
extension RoutineSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard addRoutineButton.isEnabled else {
      addRoutineButton.isEnabled = true
      addRoutineButton.backgroundColor = 0x096DB6.convertToRGB()
      return
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard tableView.indexPathsForSelectedRows != nil else {
      addRoutineButton.isEnabled = false
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
