//
//  RoutineTableView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/17.
//

import UIKit

class RoutineTableView: UITableView {
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return contentSize
  }
  
  init() {
    super.init(frame: .zero, style: .plain)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    let nib = UINib(nibName: "WorkoutPlanCardTableViewCell", bundle: nil)
    self.register(nib, forCellReuseIdentifier: WorkoutPlanCardTableViewCell.identifier)
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
