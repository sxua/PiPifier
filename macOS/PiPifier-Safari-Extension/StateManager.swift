//
//  StateManager.swift
//  PiPifier
//
//  Created by Arno on 05.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

class StateManager {
  static let shared = StateManager()
	var videosFound = [SFSafariPage: Bool]()

  private init() {}
}
