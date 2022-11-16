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
    
    FirebaseApp.configure()
    configureKakaoLogIn()
    
    if AuthenticationManager.user == nil {
      self.window?.rootViewController = SignInViewController()
    } else {
      self.window?.rootViewController = BaseTabBarController()
    }
    
    self.window?.makeKeyAndVisible()
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
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
        if let _ = error {
          DispatchQueue.main.async {
            self.window?.rootViewController = SignInViewController()
          }
        }
        
        DispatchQueue.main.async {
          self.window?.rootViewController = BaseTabBarController()
        }
      }
    }
  }
  
  func changeRootViewController(_ vc: UIViewController, animated: Bool) {
    guard let window = window else { return }
    window.rootViewController = vc
    
    UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
  }
}
