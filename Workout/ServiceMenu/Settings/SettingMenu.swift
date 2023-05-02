//
//  SettingMenu.swift
//  Workout
//
//  Created by 강인희 on 2022/11/22.
//

import Foundation

struct SettingMenu {
  let name: String
  let subMenus: [String]
  
  init(_ name: String, _ subMenus: [String]) {
    self.name = name
    self.subMenus = subMenus
  }
}
