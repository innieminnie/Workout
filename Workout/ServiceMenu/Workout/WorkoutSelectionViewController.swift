//
//  RoutineSelectionViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/04/20.
//

import UIKit

class WorkoutSelectionViewController: UIViewController, ContainWorkoutList {
  private var selectedWorkouts = [Workout]()
  weak var delegate: WorkoutSelectionDelegate?
  
  private let workoutListTableView = WorkoutListTableView()
  private lazy var addRoutineButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.tappedAddRoutineButton() })
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.configureDisableMode(title: "선택한 운동을 추가할게요")
    button.applyCornerRadius(24)
    
    return button
  }()
  
  private lazy  var noticeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let notice = "등록된 운동이 없어요.\n\"목록\"에서 운동 종목을 추가해보세요!"
    label.text = notice
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    
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

  private func tappedAddRoutineButton() {
    if let selectedWorkoutIndexPaths = self.workoutListTableView.indexPathsForSelectedRows {
      self.selectedWorkouts = selectedWorkoutIndexPaths.map({ indexPath in
        workoutManager.workout(at: indexPath)
      })
    }
  
    self.dismiss(animated: true) {
      self.delegate?.addSelectedWorkouts(self.selectedWorkouts)
    }
  }
  
  private func setUpNoticeLabel() {
    NSLayoutConstraint.activate([
      noticeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      noticeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      noticeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      noticeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ])
  }
  
  private func setUpListTableView() {
    workoutListTableView.dataSource = workoutListDataSource
    workoutListTableView.delegate = self
    workoutListTableView.allowsMultipleSelection = true
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
extension WorkoutSelectionViewController: UITableViewDelegate {
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
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = 0x096DB6.convertToRGB()
    headerView.textLabel?.font = UIFont.Pretendard(type: .Regular, size: 15)
  }
}
