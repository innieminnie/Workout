//
//  BaseTabBarController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class BaseTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllers = generateViewControllers()
  }
  
  private func generateViewControllers() -> [UIViewController] {
    let menus:[TabBarMenu] = [HomeViewController(), ListViewController()]
    
    return menus.enumerated().map { (offset, menu) in
      let navigationController = UINavigationController.init(rootViewController: menu as! UIViewController)
      navigationController.tabBarItem = UITabBarItem(title: menu.tabTitle, image: UIImage(systemName: menu.icon), tag: offset)
      navigationController.navigationBar.isHidden = true
      
      return navigationController
    }
  }
}

