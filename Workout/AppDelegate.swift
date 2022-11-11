//
//  AppDelegate.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices

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
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    appleIDProvider.getCredentialState(forUserID: "") { (credentialState, error) in
      switch credentialState {
      case .authorized:
        break
      case .revoked, .notFound:
        DispatchQueue.main.async {
          self.window?.rootViewController?.showSignInViewController()
        }
      default:
        break
      }
    }
    
    self.window?.rootViewController?.showSignInViewController()
    return true
  }
}
