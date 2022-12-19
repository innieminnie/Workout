//
//  SettingViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/21.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
  private let settingMenus = [SettingMenu("계정",["email"]), SettingMenu("지원", ["문의/의견 이메일 보내기"])]
  
  private lazy var logoutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.customizeConfiguration(with: "로그아웃", foregroundColor: .red, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
    button.backgroundColor = 0xBEC0C2.convertToRGB()
    button.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
    return button
  }()
  
  private lazy var signoutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.customizeConfiguration(with: "계정 삭제", foregroundColor: .black, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
    button.backgroundColor = 0xBEC0C2.convertToRGB()
    button.addTarget(self, action: #selector(tappedSignout), for: .touchUpInside)
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
    self.view.addSubview(signoutButton)
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
  
  @objc private func tappedSignout() {
    let alert = UIAlertController(title: "정말 계정을 삭제할건가요?", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
    let completeAction = UIAlertAction(title: "네", style: .destructive) { alertAction in
      AuthenticationManager.shared.signoutProcess()
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
      logoutButton.bottomAnchor.constraint(equalTo: signoutButton.topAnchor),
      
      signoutButton.leadingAnchor.constraint(equalTo: settingTableView.leadingAnchor),
      signoutButton.trailingAnchor.constraint(equalTo: settingTableView.trailingAnchor),
      signoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func openMail() {
    if MFMailComposeViewController.canSendMail() {
      let composeVC = MFMailComposeViewController()
      composeVC.mailComposeDelegate = self
      composeVC.setToRecipients(["pitapatpumping.help@gmail.com"])
      composeVC.setSubject("득근득근에게...")
      
      guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String else {
        return
      }
      
      composeVC.setMessageBody("이곳에 내용을 적어 보내주세요 :) \n\n\n 앱 버전정보: \(version)", isHTML: false)
      
      present(composeVC, animated: true)
    } else {
      print("메시지 전송 불가")
    }
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
    if settingMenus[indexPath.section].subMenus[indexPath.row] == "문의/의견 이메일 보내기" {
      openMail()
    }
    
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
extension SettingViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .sent:
      print("sent")
    case .cancelled:
      print("cancelled")
    case .failed:
      print("failed")
    case .saved:
      print("saved")
    @unknown default:
      fatalError()
    }
    controller.dismiss(animated: true, completion: nil)
  }
}
