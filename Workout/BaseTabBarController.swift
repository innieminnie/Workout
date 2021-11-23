//
//  BaseTabBarController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

enum Menu: Int, CaseIterable, CustomStringConvertible {
  case home
  case list
  case myPage
  
  var description: String {
    switch self {
    case .home:
      return "홈"
    case .list:
      return "목록"
    case .myPage:
      return "마이페이지"
    }
  }
  
  var icon: String {
    switch self {
    case .home:
      return "house.fill"
    case .list:
      return "list.bullet"
    case .myPage:
      return "person.fill"
    }
  }
}

class BaseTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllers = generateViewControllers()
  }
  
  private func generateViewControllers() -> [UIViewController] {
    return Menu.allCases.map { menu in
      let navigationController = UINavigationController.init(rootViewController: ViewController(title: menu.description))
      let tabBarItem = UITabBarItem(title: menu.description, image: UIImage(systemName: menu.icon), tag: menu.rawValue)
      navigationController.tabBarItem = tabBarItem
      return navigationController
    }
  }
}

