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
  }
  
  @objc private func tappedAppleSignInButton() {
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
  
  @objc private func tappedKakaoSignInButton() {
    AuthenticationManager.shared.kakaoLoginProcess(presentingVC: self)
  }
  
  func completeSignInProcess() {
    let baseTabBarController = BaseTabBarController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.changeRootViewController(baseTabBarController, animated: true)
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
          print(error.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        self.completeSignInProcess()
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print(error)
  }
}
