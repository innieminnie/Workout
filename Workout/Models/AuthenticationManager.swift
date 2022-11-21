//
//  AuthenticationManager.swift
//  Workout
//
//  Created by 강인희 on 2022/11/15.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

class AuthenticationManager {
  static let shared = AuthenticationManager()
  static let user = Auth.auth().currentUser
  static var userEmail = ""
  
  private init() { }
  
  func setAccountInformation(_ email: String) {
    AuthenticationManager.userEmail = email
  }
  
  func googleLoginProcess(presentingVC: SignInViewController) {
    guard let clientID = APIKey().googleClientID else { return }
    let config = GIDConfiguration.init(clientID: clientID)
    
    GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { user, error in
      if let error = error {
        print(error)
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { autoDataResult, error in
        if let error = error { print(error) }
        else {
          presentingVC.completeSignInProcess()
        }
      }
    }
  }
  
  
  func appleLoginProcess(with authorizationController: ASAuthorizationController) {
    authorizationController.performRequests()
  }
  
  func kakaoLoginProcess(presentingVC: SignInViewController) {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        self.onKakaoLoginCompleted(oauthToken?.accessToken, presentingVC)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        self.onKakaoLoginCompleted(oauthToken?.accessToken, presentingVC)
      }
    }
  }
  
  func onKakaoLoginCompleted(_ accessToken: String?,_ presentingVC: SignInViewController) {
    connectFirebaseAuthentication(accessToken, presentingVC)
  }
  
  func connectFirebaseAuthentication(_ accessToken: String?, _ presentingVC: SignInViewController) {
    UserApi.shared.me() { user, error in
      if error == nil {
        guard let user = user, let kakaoEmail = user.kakaoAccount?.email, let id = user.id else {
          return
        }
        
        Auth.auth().createUser(withEmail: kakaoEmail, password: String(describing: id)) { autoDataResult, error in
          if error != nil {
            Auth.auth().signIn(withEmail: kakaoEmail, password: String(describing: id), completion: nil)
            presentingVC.completeSignInProcess()
          }
        }
      }
    }
  }
}

let currentUser = AuthenticationManager.user
