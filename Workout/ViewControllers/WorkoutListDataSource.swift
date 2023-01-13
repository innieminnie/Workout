//
//  WorkoutListDataSource.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import UIKit

class WorkoutListDataSource: NSObject, UITableViewDataSource {
  private var isSearching = false
  private var searchingList = [Workout]()
  
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
}
extension WorkoutListDataSource: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.isSearching = false
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.isSearching = true
  }
}
