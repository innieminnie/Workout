//
//  ViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class HomeViewController: UIViewController {
  var workouts = [Workout]()
  
  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  
  private let calendarView = CalendarView(frame: .zero)
  
  private let addRoutineButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitle("루틴 추가하기", for: .normal)
    button.layer.cornerRadius = 13
    button.backgroundColor = .purple
    button.addTarget(self, action: #selector(tappedAddRoutineButton(sender:)), for: .touchUpInside)
    
    return button
  }()
  
  private let routineTableView = RoutineTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(contentScrollView)
    
    contentScrollView.addSubview(calendarView)
    contentScrollView.addSubview(addRoutineButton)
    contentScrollView.addSubview(routineTableView)
    
    routineTableView.delegate = self
    routineTableView.dataSource = self
    
    setUpLayout()
  }
  
  @objc func tappedAddRoutineButton(sender: UIButton) {
    let routineSelectionViewController = RoutineSelectionViewController()
    routineSelectionViewController.delegate = self
    routineSelectionViewController.modalPresentationStyle = .formSheet
    self.present(routineSelectionViewController, animated: true, completion: nil)
  }
  
  private func setUpLayout() {    
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      
      calendarView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: 30),
      calendarView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
      calendarView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
      calendarView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),

      addRoutineButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
      addRoutineButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
      addRoutineButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
      
      routineTableView.topAnchor.constraint(equalTo: addRoutineButton.bottomAnchor, constant: 10),
      routineTableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
      routineTableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
      routineTableView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
    ])
  }
}
extension HomeViewController: RoutineSelectionDelegate {
  func addSelectedWorkouts(_ selectedWorkouts: [Workout]) {
    self.workouts += selectedWorkouts
    routineTableView.reloadData()
    routineTableView.layoutIfNeeded()
  }
}
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutPlanCardTableViewCell.identifier, for: indexPath) as? WorkoutPlanCardTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workouts[indexPath.row]
    cell.setUp(with: workout)
    
    return cell
  }
  
  
}
extension HomeViewController: UITableViewDelegate {
  
}
extension HomeViewController: TabBarMenu {
  var tabTitle: String {
    return "홈"
  }
  
  var icon: String {
    return "house.fill"
  }
}


