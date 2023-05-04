//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class WorkoutListViewController: UITableViewController, ContainWorkoutList {
  private lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { _ in self.addButtonTouched() })
    return button
  }()
  
  weak var delegate: SendingWorkoutDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setUpListTableView()
    setUpNavigationController()
    setUpSearchController()
    
    workoutManager.workoutViewDelegate = self
  }
  
  private func addButtonTouched() {
    let newWorkoutViewController = WorkoutInformationViewController()
    newWorkoutViewController.updateWorkoutDelegate = self
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.present(newWorkoutViewController, animated: true)
    }
  }
  
  private func setUpListTableView() {
    self.tableView = WorkoutListTableView()
    self.tableView.dataSource = workoutListDataSource
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
    searchController.searchBar.delegate = self.workoutListDataSource
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.searchController = searchController
  }
}
extension WorkoutListViewController {
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = 0x096DB6.convertToRGB()
    headerView.textLabel?.font = UIFont.Pretendard(type: .Regular, size: 15)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let workout = workoutListDataSource.isSearching ? workoutListDataSource.searchingList[indexPath.row] : workoutManager.workout(at: indexPath)
    let workoutInformationViewController = WorkoutInformationViewController()
    self.delegate = workoutInformationViewController
    workoutInformationViewController.updateWorkoutDelegate = self
    delegate?.showInformation(of: workout)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.present(workoutInformationViewController, animated: true)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
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
  }
  
  func updateWorkout(code: String, name: String, weightUnit: WeightUnit, bodySection: BodySection ) {
    workoutManager.updateWorkout(code, name, weightUnit, bodySection)
  }
}
extension WorkoutListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchingText = searchController.searchBar.searchTextField.text else {
      return
    }
    
    self.workoutListDataSource.showSearchData(searchingList:  workoutManager.searchWorkouts(by: searchingText))
    self.tableView.reloadData()
  }
}
extension WorkoutListViewController: WorkoutViewDelegate {
  func workoutAdded() {
    self.tableView.reloadData()
  }
  
  func workoutChanged() {
    self.tableView.reloadData()
  }
  
  func workoutRemoved(at indexPath: IndexPath) {
    self.tableView.beginUpdates()
    self.tableView.deleteRows(at: [indexPath], with: .fade)
    self.tableView.endUpdates()
  }
}
