//
//  AuthenticationManager.swift
//  Workout
//
//  Created by 강인희 on 2022/11/15.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import KakaoSDKAuth
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
        let alert = UIAlertController(title: "\(error)\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alert.addAction(action)
        presentingVC.present(alert, animated: false, completion: nil)
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { autoDataResult, error in
        if let error = error {
          let alert = UIAlertController(title: "\(error)\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
          alert.addAction(action)
          presentingVC.present(alert, animated: false, completion: nil)
        }
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
            let errorCode = AuthErrorCode(rawValue: error!._code)
            switch errorCode {
            case .emailAlreadyInUse:
              let alert = UIAlertController(title: "다른 로그인 방식으로 해당 이메일 계정을 사용한 기록이 있어요.\n\n 다른 로그인 방식을 시도해주세요!", message: nil, preferredStyle: .alert)
              let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
              alert.addAction(action)
              presentingVC.present(alert, animated: false, completion: nil)
              return
              
            default:
              Auth.auth().signIn(withEmail: kakaoEmail, password: String(describing: id), completion: nil)
            }
          }
          
          presentingVC.completeSignInProcess()
        }
      }
    }
  }
  
  func logoutProcess() {
    do {
      try Auth.auth().signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    
    if (AuthApi.hasToken()) {
      UserApi.shared.logout {(error) in
        if let error = error {
          print(error)
        }
        else {
          print("logout() success.")
        }
      }
    }
  }
}

let currentUser = AuthenticationManager.user
