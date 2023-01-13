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
    let button = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { _ in self.addButtonTouched() })
    return button
  }()
  private var dataSource: WorkoutListDataSource!
  
  weak var delegate: SendingWorkoutDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setUpListTableView()
    setUpNavigationController()
    setUpSearchController()
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = 0x096DB6.convertToRGB()
    headerView.textLabel?.font = UIFont.Pretendard(type: .Regular, size: 15)
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
  
  func updateWorkout(code: String, name: String, weightUnit: WeightUnit, bodySection: BodySection ) {
    workoutManager.updateWorkout(code, name, weightUnit, bodySection)
    tableView.reloadData()
  }

}
extension WorkoutListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchingText = searchController.searchBar.searchTextField.text else {
      return
    }

    self.dataSource.showSearchData(searchingList:  workoutManager.searchWorkouts(by: searchingText))
    self.tableView.reloadData()
  }
}
extension WorkoutListViewController {
  private func addButtonTouched() {
    let newWorkoutViewController = WorkoutInformationViewController()
    newWorkoutViewController.updateWorkoutDelegate = self
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.present(newWorkoutViewController, animated: true)
    }
  }
  
  private func setUpListTableView() {
    self.tableView = WorkoutListTableView()
    self.dataSource = WorkoutListDataSource()
    self.tableView.dataSource = dataSource
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
    searchController.searchBar.delegate = self.dataSource
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.searchController = searchController
  }
}
