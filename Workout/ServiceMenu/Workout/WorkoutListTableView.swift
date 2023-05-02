//
//  WorkoutListTableView.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/13.
//

import UIKit

class WorkoutListTableView: UITableView {
  init() {
    super.init(frame: .zero, style: .plain)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
    self.register(nib, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
