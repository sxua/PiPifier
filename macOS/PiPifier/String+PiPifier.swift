//
//  String+PiPifier.swift
//  PiPifier
//
//  Created by Oleksandr Skrypnyk on 6/24/21.
//  Copyright © 2021 APPenzeller. All rights reserved.
//

import Foundation

extension String {
  func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
    NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
  }
}
