//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

protocol SendingWorkoutDelegate: AnyObject {
  func showInformation(of workout: Workout)
}

class WorkoutListViewController: UITableViewController {
  private lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTouched(_:)))
    return button
  }()
  
  private var searchingList = [Workout]()
  
  private var isSearching: Bool {
    let isSearchBarActive = self.navigationItem.searchController?.isActive ?? false
    let isSearchBarEmpty = self.navigationItem.searchController?.searchBar.text?.isEmpty ?? false
    return isSearchBarActive && !isSearchBarEmpty
  }
  
  weak var delegate: SendingWorkoutDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpNavigationController()
    setUpSearchController()
    setUpListTableView()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.isSearching ? 1 : BodySection.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let bodySection = BodySection.allCases[section]
    return self.isSearching ? self.searchingList.count : workoutManager.filteredWorkout(by: bodySection).count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = self.isSearching ? self.searchingList[indexPath.row] : workoutManager.workout(at: indexPath)
    cell.setUp(with: workout)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let bodySection = BodySection.allCases[section]
    if !self.isSearching && workoutManager.filteredWorkout(by: bodySection).count == 0 { return nil }
    
    return self.isSearching ? "검색결과" : BodySection.allCases[section].rawValue
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = 0x096DB6.convertToRGB()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let workout = workoutManager.workout(at: indexPath)
    let workoutInformationViewController = WorkoutInformationViewController()
    self.delegate = workoutInformationViewController
    workoutInformationViewController.updateWorkoutDelegate = self
    delegate?.showInformation(of: workout)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.present(workoutInformationViewController, animated: true)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let removingWorkout = workoutManager.workout(at: indexPath)
      workoutManager.removeWorkout(removingWorkout)
      tableView.deleteRows(at: [indexPath], with: .automatic)
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
extension WorkoutListViewController: UpdateWorkoutDelegate {
  func saveNewWorkout(workout: Workout) {
    workoutManager.register(workout: workout)
    tableView.reloadData()
  }
  
  func updateWorkout(code: String, name: String, bodySection: BodySection ) {
    workoutManager.updateWorkout(code, name, bodySection)
    tableView.reloadData()
  }

}
extension WorkoutListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchingText = searchController.searchBar.searchTextField.text else {
      return
    }
    
    self.searchingList = workoutManager.searchWorkouts(by: searchingText)
    self.tableView.reloadData()
  }
}
extension WorkoutListViewController {
  @objc private func buttonTouched(_ sender: UIBarButtonItem) {
    let newWorkoutViewController = WorkoutInformationViewController()
    newWorkoutViewController.updateWorkoutDelegate = self
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.present(newWorkoutViewController, animated: true)
    }
  }
  
  private func setUpNavigationController() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.topItem?.title = "나의 운동 목록"
    self.navigationController?.navigationBar.topItem?.rightBarButtonItem = addButton
  }
  
  private func setUpSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.searchController = searchController
  }
  
  private func setUpListTableView() {
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
    self.tableView.separatorStyle = .none
  }
}
