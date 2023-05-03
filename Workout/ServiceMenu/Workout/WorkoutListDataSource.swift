//
//  WorkoutListDataSource.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import UIKit

protocol ContainWorkoutList {
  var workoutListDataSource: WorkoutListDataSource { get }
}
extension ContainWorkoutList {
    var workoutListDataSource: WorkoutListDataSource {
      return WorkoutListDataSource.shared
    }
}

class WorkoutListDataSource: NSObject, UITableViewDataSource {
  static let shared = WorkoutListDataSource()
  
  var isSearching = false
  var searchingList = [Workout]()
  
  private override init() { }
  
  func showSearchData(searchingList: [Workout]) {
    self.searchingList = searchingList
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return isSearching ? 1 : BodySection.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let bodySection = BodySection.allCases[section]
    return  isSearching ? self.searchingList.count : workoutManager.filteredWorkout(by: bodySection).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = isSearching ? self.searchingList[indexPath.row] : workoutManager.workout(at: indexPath)
    cell.setUp(with: workout)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let bodySection = BodySection.allCases[section]
    if isSearching && workoutManager.filteredWorkout(by: bodySection).count == 0 { return nil }
    
    return isSearching ? "검색결과" : workoutManager.filteredWorkout(by: bodySection).count == 0 ? nil : BodySection.allCases[section].rawValue
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let removingWorkout = workoutManager.workout(at: indexPath)
      workoutManager.removeWorkout(removingWorkout)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
extension WorkoutListDataSource: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.isSearching = false
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.isSearching = true
  }
}
