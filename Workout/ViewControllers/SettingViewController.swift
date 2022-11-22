//
//  SettingViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/21.
//

import UIKit

class SettingViewController: UIViewController {
  private let settingMenus = [SettingMenu("계정",["email"]), SettingMenu("지원", ["알림 설정", "문의/의견 이메일 보내기", "앱 리뷰 작성하기", "버전 정보"])]
  
  private lazy var logoutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.customizeConfiguration(with: "로그아웃", foregroundColor: .red, font: .systemFont(ofSize: 15), buttonSize: .medium)
    button.backgroundColor = 0xBEC0C2.convertToRGB()
    button.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
    return button
  }()
  
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
    self.view.addSubview(logoutButton)
    settingTableView.delegate = self
    settingTableView.dataSource = self
    
    setUpLayout()
  }
  
  @objc private func tappedLogout() {
    let alert = UIAlertController(title: "정말 로그아웃할건가요?", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
    let completeAction = UIAlertAction(title: "네", style: .destructive) { alertAction in
      AuthenticationManager.shared.logoutProcess()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.changeRootViewController(SignInViewController(), animated: true)
    }
    
    alert.addAction(cancelAction)
    alert.addAction(completeAction)
    self.present(alert, animated: false, completion: nil)
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      settingTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      settingTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      settingTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      settingTableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor),
      
      logoutButton.leadingAnchor.constraint(equalTo: settingTableView.leadingAnchor),
      logoutButton.trailingAnchor.constraint(equalTo: settingTableView.trailingAnchor),
      logoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return settingMenus.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingMenus[section].subMenus.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return settingMenus[section].name
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
    cell.setUp(with: settingMenus[indexPath.section].subMenus[indexPath.row])
    return cell
  }
}
extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
extension SettingViewController: TabBarMenu {
  var tabTitle: String {
    return "설정"
  }
  
  var icon: String {
    return "gearshape.fill"
  }
  
  
}
