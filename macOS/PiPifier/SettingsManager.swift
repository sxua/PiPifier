//
//  SettingsManager.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 16.10.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Foundation

class SettingsManager {
  static let shared = SettingsManager()

  let sharedUserDefaults = UserDefaults(suiteName: "24T8GUQ6KA.group.pipifier")!
  let buttonEnabledKey = "customPiPButtonsEnabled"

  var isCustomPiPButtonsEnabled: Bool {
    get {
      sharedUserDefaults.value(forKey: buttonEnabledKey) as? Bool ?? true
    }
    set {
      sharedUserDefaults.set(newValue, forKey: buttonEnabledKey)
    }
  }

  private init() {}
}
