//
//  SignInViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/11.
//

import UIKit
import AuthenticationServices
import FirebaseAuth



class SignInViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setUpLoginButtons()
  }
  
  private func setUpLoginButtons() {
    let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    appleLoginButton.addTarget(self, action: #selector(tappedAppleSignInButton), for: .touchUpInside)
    self.view.addSubview(appleLoginButton)
    
    let kakaoLoginButton = UIButton()
    kakaoLoginButton.setImage(#imageLiteral(resourceName: "kakao_login_large_wide"), for: .normal)
    kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
    kakaoLoginButton.addTarget(self, action: #selector(tappedKakaoSignInButton), for: .touchUpInside)
    self.view.addSubview(kakaoLoginButton)
    
    NSLayoutConstraint.activate([
      appleLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      appleLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      appleLoginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      
      kakaoLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      kakaoLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      kakaoLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 20)
    ])
  }
  
  @objc private func tappedAppleSignInButton() {
    //애플로그인과정진행
  }
  
  @objc private func tappedKakaoSignInButton() {
    AuthenticationManager.shared.kakaoLoginProcess()
    self.dismiss(animated: true)
  }
}
