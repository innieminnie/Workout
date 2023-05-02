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
  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  let minimumVersion = "1.0.4"
  static var signedUpUser = String()
  static var userEmail = ""
  
  private init() { }
  
  func setAccountInformation(_ email: String) {
    AuthenticationManager.userEmail = email
  }
  
  func googleLoginProcess(presentingVC: SignInViewController) {
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
      guard error == nil else { return }
      guard let signInResult = signInResult else { return }
      
      signInResult.user.refreshTokensIfNeeded { user, error in
        guard error == nil else {
          let alert = UIAlertController(title: "\(String(describing: error))\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
          alert.addAction(action)
          presentingVC.present(alert, animated: false, completion: nil)
          return
        }
        
        guard let user = user else {
          let alert = UIAlertController(title: "\(String(describing: error))\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
          alert.addAction(action)
          presentingVC.present(alert, animated: false, completion: nil)
          return
        }
        
        guard let idToken = user.idToken?.tokenString else {
          let alert = UIAlertController(title: "\(String(describing: error))\n 로그인에 실패했어요. 잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
          alert.addAction(action)
          presentingVC.present(alert, animated: false, completion: nil)
          return
        }
        
        let accessToken = user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
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
          if let error = error {
            let nsError = error as NSError
            let errorCode = AuthErrorCode.Code.init(rawValue: nsError.code)
            
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
  
  func signoutProcess() {
    logoutProcess()
    AuthenticationManager.user?.delete { error in
      if let error = error {
        print(error)
      } else {
        print("delete success.")
      }
    }
  }
  
  func checkMinimumVersion(completionHandler: @escaping (String) -> Void ) {
    guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(APIKey.appID)") else { return }
    
    let requestURL = URLRequest(url: url)
    URLSession.shared.dataTask(with: requestURL) { data, response, error in
      if let error = error { print(error); return }
      
      if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
          let results = json!["results"] as? [[String: Any]]
          let appStoreVersion = results![0]["version"] as? String
          completionHandler(appStoreVersion!)
        } catch {
          print(error.localizedDescription)
        }
      }
    }.resume()
  }
}

let currentUser = AuthenticationManager.user
