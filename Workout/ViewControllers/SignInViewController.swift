//
//  SignInViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/11.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setUpLoginButtons()
  }
  
  private func setUpLoginButtons() {
    let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    
    signInButton.addTarget(self, action: #selector(tappedAppleSignInButton), for: .touchUpInside)
    self.view.addSubview(signInButton)
    
    NSLayoutConstraint.activate([
      signInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      signInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])
    
    let button = UIButton()
    button.setTitle("카카오", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemYellow
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(tappedKakaoSignInButton), for: .touchUpInside)
    self.view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      button.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20)
    ])
  }
  
  @objc private func tappedAppleSignInButton() {
    //애플로그인과정진행
  }
  
  @objc private func tappedKakaoSignInButton() {
    //카카오로그인과정진행
  }
}
