//
//  AppDelegate.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit
import Network
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
  let monitor = NWPathMonitor()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.overrideUserInterfaceStyle = .light
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
    setMonitor()
    FirebaseApp.configure()
    KakaoSDK.initSDK(appKey: APIKey.kakaoNativeAppKey)
    
    self.window?.rootViewController = SplashViewController()
    self.window?.makeKeyAndVisible()
    
    workoutManager.test() //수정필요
    
    return true
  }
  
  func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) { return true }
    else if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    return false
  }
  
  func changeRootViewController(_ vc: UIViewController, animated: Bool) {
    guard let window = window else { return }
    
    DispatchQueue.main.async {
      window.rootViewController = vc
      UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
  }
  
  func setMonitor() {
    monitor.start(queue: .global())
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        DispatchQueue.main.async {
          if self.window?.rootViewController is NetworkConfirmViewController {
            if AuthenticationManager.user == nil {
              self.changeRootViewController(SignInViewController(), animated: true)
            } else {
              self.changeRootViewController(BaseTabBarController(), animated: true)
            }
          } else if self.window?.rootViewController == nil {
            if AuthenticationManager.user == nil {
              self.window?.rootViewController = SignInViewController()
            } else {
              self.window?.rootViewController = BaseTabBarController()
            }
            
            return
          }
        }
      } else {
        self.changeRootViewController(NetworkConfirmViewController(), animated: true)
      }
    }
  }
}
