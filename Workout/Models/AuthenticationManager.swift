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

  private init() { }
  
  func googleLoginProcess(presentingVC: UIViewController) {
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
      }
    }
  }
  
  func appleLoginProcess(with authorizationController: ASAuthorizationController) {
    authorizationController.performRequests()
  }
  
  func kakaoLoginProcess() {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        self.onKakaoLoginCompleted(oauthToken?.accessToken)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        self.onKakaoLoginCompleted(oauthToken?.accessToken)
      }
    }
  }
  
  func onKakaoLoginCompleted(_ accessToken: String?) {
    connectFirebaseAuthentication(accessToken)
  }
  
  func connectFirebaseAuthentication(_ accessToken: String?) {
    UserApi.shared.me() { user, error in
      if error == nil {
        guard let user = user, let kakaoEmail = user.kakaoAccount?.email, let id = user.id else {
          return
        }
        
        Auth.auth().createUser(withEmail: kakaoEmail, password: String(describing: id)) { autoDataResult, error in
          if error != nil {
            Auth.auth().signIn(withEmail: kakaoEmail, password: String(describing: id), completion: nil)
          }
        }
      }
    }
  }
}

let currentUser = AuthenticationManager.user
