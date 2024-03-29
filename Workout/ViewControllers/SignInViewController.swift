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
import CryptoKit

class SignInViewController: UIViewController {
  fileprivate var currentNonce: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setUpLoginButtons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 2) {
      self.buttonsStackView.alpha = 1
    }
  }
  
  private lazy var logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "signin_logo")
    
    return imageView
  }()
  
  private lazy var buttonsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .vertical
    stackView.spacing = 5
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.alpha = 0
    
    return stackView
  }()
  
  private func setUpLoginButtons() {
    let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    appleLoginButton.addAction(UIAction { _ in self.tappedAppleSignInButton() }, for: .touchUpInside)
    
    let googleLoginButton = GIDSignInButton()
    googleLoginButton.addAction(UIAction { _ in self.tappedGoogleSignInButton() }, for: .touchUpInside)
    googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    googleLoginButton.colorScheme = .dark
    googleLoginButton.style = .wide
    googleLoginButton.backgroundColor = 0x4285F4.convertToRGB()
    googleLoginButton.layer.cornerRadius = 6
    
    let kakaoLoginButton = UIButton()
    kakaoLoginButton.addAction(UIAction { _ in self.tappedKakaoSignInButton() }, for: .touchUpInside)
    kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
    kakaoLoginButton.backgroundColor = 0xFEE500.convertToRGB()
    kakaoLoginButton.setImage(#imageLiteral(resourceName: "kakao_login_large_wide"), for: .normal)
    kakaoLoginButton.layer.cornerRadius = 6
    kakaoLoginButton.imageView?.contentMode = .scaleAspectFill
    
    buttonsStackView.addArrangedSubview(appleLoginButton)
    buttonsStackView.addArrangedSubview(googleLoginButton)
    buttonsStackView.addArrangedSubview(kakaoLoginButton)
    
    self.view.addSubview(buttonsStackView)
    self.view.addSubview(logoImageView)
    
    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      logoImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
      
      appleLoginButton.widthAnchor.constraint(equalTo: googleLoginButton.widthAnchor),
      kakaoLoginButton.widthAnchor.constraint(equalTo: googleLoginButton.widthAnchor),
      appleLoginButton.heightAnchor.constraint(equalTo: googleLoginButton.heightAnchor),
      kakaoLoginButton.heightAnchor.constraint(equalTo: googleLoginButton.heightAnchor),
      
      buttonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      buttonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      buttonsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
    ])
  }
  
  func completeSignInProcess() {
    let baseTabBarController = BaseTabBarController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.changeRootViewController(baseTabBarController, animated: true)
  }
}
extension SignInViewController {
  private func tappedGoogleSignInButton() {
    AuthenticationManager.shared.googleLoginProcess(presentingVC: self)
  }
  
  private func tappedAppleSignInButton() {
    let nonce = randomNonceString()
    currentNonce = nonce
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.email, .fullName]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    
    AuthenticationManager.shared.appleLoginProcess(with: authorizationController)
  }
  
  private func tappedKakaoSignInButton() {
    AuthenticationManager.shared.kakaoLoginProcess(presentingVC: self)
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
  
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }
        return random
      }
      
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    
    return result
  }
}
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          
          let alert = UIAlertController(title: "\(error.localizedDescription)\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
          alert.addAction(action)
          self.present(alert, animated: false, completion: nil)
          return
        }
        // User is signed in to Firebase with Apple.
        self.completeSignInProcess()
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    let alert = UIAlertController(title: "\(error.localizedDescription)\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: false, completion: nil)
    return
  }
}
