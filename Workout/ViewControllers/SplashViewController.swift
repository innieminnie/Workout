//
//  SplashViewController.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/17.
//

import UIKit

class SplashViewController: UIViewController {
  static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(APIKey.appID)"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    AuthenticationManager.shared.checkMinimumVersion { minimumVersion in
      if self.compareVersion(versionA: AuthenticationManager.shared.appVersion!, versionB: minimumVersion) {
        let alert = UIAlertController(title: "업데이트 알림", message: "필수 업데이트가 있어요! 앱스토어에서 최신 버전으로 업데이트 해주세요. :)", preferredStyle: .alert)
        alert.addAction(.init(title: "업데이트", style: .default, handler: {_ in
          self.openAppStore(urlStr: SplashViewController.appStoreOpenUrlString)
        }))
        
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
      } else {
        DispatchQueue.main.async {
          self.changeRootViewController()
        }
      }
    }
  }
  
  private func openAppStore(urlStr: String) {
    guard let url = URL(string: urlStr) else {
      print("invalid app store url")
      return
    }
    
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
      return
    } else {
      print("can't open app store url")
      return
    }
  }
  
  private func compareVersion(versionA:String, versionB:String) -> Bool {
    let compareResult = versionA.compare(versionB, options: .numeric)
    
    if compareResult == .orderedAscending {
      return true
    }
    
    return false
  }
  
  private func changeRootViewController() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    if AuthenticationManager.user == nil {
      appDelegate.changeRootViewController(SignInViewController(), animated: true)
    } else {
      appDelegate.changeRootViewController(BaseTabBarController(), animated: true)
    }
  }
}
