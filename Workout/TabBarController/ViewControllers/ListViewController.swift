//
//  ListViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class ListViewController: UIViewController {
  private lazy var addButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("새로운 운동 추가", for: .normal)
    button.backgroundColor = .systemPurple
    button.layer.cornerRadius = 13.0
    button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(addButton)
    setUpLayout()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
      addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
}
extension ListViewController: TabBarMenu {
  var tabTitle: String {
    "목록"
  }
  
  var icon: String {
    "list.bullet"
  }
}
