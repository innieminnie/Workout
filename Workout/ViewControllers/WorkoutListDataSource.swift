//
//  WorkoutListDataSource.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import UIKit

class WorkoutListDataSource: NSObject, UITableViewDataSource {
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
}
