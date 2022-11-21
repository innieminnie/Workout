//
//  SettingViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/21.
//

import UIKit

class SettingViewController: UIViewController {
  var labelTitles = ["계정", "로그아웃"]
  
  private lazy var settingTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier:SettingTableViewCell.identifier)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(settingTableView)
    settingTableView.delegate = self
    settingTableView.dataSource = self
    
    setUpLayout()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      settingTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      settingTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      settingTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      settingTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "계정"
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
    cell.setUp(with: labelTitles[indexPath.row])
    return cell
  }
}
extension SettingViewController: UITableViewDelegate {
  
}
extension SettingViewController: TabBarMenu {
  var tabTitle: String {
    return "설정"
  }
  
  var icon: String {
    return "gearshape.fill"
  }
  
  
}
