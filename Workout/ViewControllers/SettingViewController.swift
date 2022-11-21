//
//  SettingViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/21.
//

import UIKit

class SettingViewController: UIViewController {
  var labelTitles = ["계정", "로그아웃"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier:SettingTableViewCell.identifier)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "로그인 정보"
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
    return "사용자정보"
  }
  
  var icon: String {
    return "gearshape.fill"
  }
  
  
}
