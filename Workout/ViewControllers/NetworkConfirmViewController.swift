//
//  NetworkConfirmViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/23.
//

import Foundation
import UIKit

class NetworkConfirmViewController: UIViewController {
  private lazy  var noticeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let notice = "네트워크 연결이 원활하지 않아요 :(. \n 네트워크 연결 설정 후, 다시 시도해주세요!"
    label.text = notice
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    
    return label
  }()
  
//  private lazy var retryButton: UIButton = {
//    let button = UIButton()
//    button.translatesAutoresizingMaskIntoConstraints = false
//
//    button.customizeConfiguration(with: "재시도", foregroundColor: .white, font: UIFont.boldSystemFont(ofSize: 15), buttonSize: .medium)
//    button.backgroundColor = 0x096DB6.convertToRGB()
//    button.applyCornerRadius(12)
//    button.isEnabled = false
//    self.retryButton.addTarget(self, action: #selector(tappedRetryButton), for: .touchUpInside)
//
//    return button
//  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.view.addSubview(noticeLabel)
//    self.view.addSubview(retryButton)
    setUpLayout()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      noticeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
      noticeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
      noticeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      noticeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      
//      retryButton.topAnchor.constraint(equalTo: noticeLabel.bottomAnchor, constant: 10),
//      retryButton.leadingAnchor.constraint(equalTo: noticeLabel.leadingAnchor),
//      retryButton.trailingAnchor.constraint(equalTo: noticeLabel.trailingAnchor)
    ])
  }
  
  func activateRetryButton() {
//    retryButton.isEnabled = true
  }
  @objc private func tappedRetryButton() {
    self.dismiss(animated: true)
  }
}

extension UIViewController {
  func showNetworkConfirmVC() {
    let networkViewController = NetworkConfirmViewController()
    
    DispatchQueue.main.async {
      self.modalPresentationStyle = .fullScreen
      self.present(networkViewController, animated: true)
    }
  }
}
