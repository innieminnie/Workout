//
//  SignInViewController.swift
//  Workout
//
//  Created by 강인희 on 2022/11/11.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn


class SignInViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setUpLoginButtons()
  }
  
  private func setUpLoginButtons() {
    let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    appleLoginButton.addTarget(self, action: #selector(tappedAppleSignInButton), for: .touchUpInside)
    self.view.addSubview(appleLoginButton)
    
    let googleLoginButton = GIDSignInButton()
    googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    googleLoginButton.colorScheme = .dark
    googleLoginButton.style = .wide
    googleLoginButton.addTarget(self, action: #selector(tappedGoogleSignInButton), for: .touchUpInside)
    self.view.addSubview(googleLoginButton)
    
    let kakaoLoginButton = UIButton()
    kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
    kakaoLoginButton.backgroundColor = 0xFEE500.converToRGB()
    
    kakaoLoginButton.setImage(#imageLiteral(resourceName: "kakao_login_large_wide"), for: .normal)
    kakaoLoginButton.addTarget(self, action: #selector(tappedKakaoSignInButton), for: .touchUpInside)
    self.view.addSubview(kakaoLoginButton)
    
    NSLayoutConstraint.activate([
      appleLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      appleLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      appleLoginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      
      googleLoginButton.leadingAnchor.constraint(equalTo: appleLoginButton.leadingAnchor),
      googleLoginButton.trailingAnchor.constraint(equalTo: appleLoginButton.trailingAnchor),
      googleLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 10),
      
      kakaoLoginButton.leadingAnchor.constraint(equalTo: appleLoginButton.leadingAnchor),
      kakaoLoginButton.trailingAnchor.constraint(equalTo: appleLoginButton.trailingAnchor),
      kakaoLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
    ])
  }
  
  @objc private func tappedGoogleSignInButton() {
    AuthenticationManager.shared.googleLoginProcess(presentingVC: self)
    self.dismiss(animated: true)
  }
  
  @objc private func tappedAppleSignInButton() {
    AuthenticationManager.shared.appleLoginProcess()
    self.dismiss(animated: true)
  }
  
  @objc private func tappedKakaoSignInButton() {
    AuthenticationManager.shared.kakaoLoginProcess()
    self.dismiss(animated: true)
  }
}
