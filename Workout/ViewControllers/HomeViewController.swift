//
//  ViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class HomeViewController: UIViewController {
  let calendarView = CalendarView(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(calendarView)
    setUpLayout()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      calendarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
      calendarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      calendarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      calendarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
    ])
  }
}
extension HomeViewController: TabBarMenu {
  var tabTitle: String {
    return "홈"
  }
  
  var icon: String {
    return "house.fill"
  }
}


