//
//  AppDelegate.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit
import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = BaseTabBarController()
    window?.makeKeyAndVisible()
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
    FirebaseApp.configure()
    if AuthenticationManager.user == nil { configureKakaoLogIn() }
    
    return true
  }
  
  func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) { return true }
    else if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    return false
  }
  
  private func configureKakaoLogIn() {
    KakaoSDK.initSDK(appKey: APIKey().kakaoNativeAppKey)
    
    if (AuthApi.hasToken()) {
      UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
        if let error = error {
          self.window?.rootViewController?.showSignInViewController()
        }
      }
    }
    else {
      self.window?.rootViewController?.showSignInViewController()
    }
  }
}
