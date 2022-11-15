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

class AuthenticationManager {
  static let shared = AuthenticationManager()
  static let user = Auth.auth().currentUser

  private init() { }
  
  func kakaoLoginProcess() {
    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
      UserApi.shared.me { (user,error) in
        guard let user = user, let kakaoEmail = user.kakaoAccount?.email, let id = user.id else {
          return
        }
        
        Auth.auth().createUser(withEmail: kakaoEmail, password: String(describing: id)) { (autoDataResult, error) in
          if let error = error {
            print(error)
            Auth.auth().signIn(withEmail: kakaoEmail, password: String(describing: id)) { (autoDataResult, error) in
            }
          }
        }
      }
    }
  }
}
let currentUser = AuthenticationManager.user
