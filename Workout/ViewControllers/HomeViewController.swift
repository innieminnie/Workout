//
//  ViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class HomeViewController: UIViewController {
  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let calendarView = CalendarView(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(contentScrollView)
    contentScrollView.addSubview(calendarView)
    setUpLayout()
  }
  
  private func setUpLayout() {
    let scrollHeightContraint = calendarView.heightAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.heightAnchor)
    scrollHeightContraint.priority = UILayoutPriority(250)
    
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      
      calendarView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: 30),
      calendarView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
      calendarView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
      calendarView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
      
      calendarView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),
      scrollHeightContraint
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


