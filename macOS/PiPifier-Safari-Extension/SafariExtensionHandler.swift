//
//  SafariExtensionHandler.swift
//  PiPifier-Safari-Extension
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

enum Message: String {
	case videoCheck, pipCheck
}

class SafariExtensionHandler: SFSafariExtensionHandler {
  let settingsManager = SettingsManager.shared

  override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]? = nil) {
    guard let message = Message(rawValue: messageName) else {
      NSLog("INFO: unhandled message")
      return
    }

    NSLog("INFO: recieved message: \(message)")
    switch message {
    case .videoCheck:
      NSLog("INFO: videoCheck: \(userInfo?["found"] as? Bool ?? false)")
      StateManager.shared.videosFound[page] = userInfo?["found"] as? Bool ?? false
      SFSafariApplication.setToolbarItemsNeedUpdate()
    case .pipCheck:
      pipCheck(callback: userInfo?["callback"])
    }
  }

  override func toolbarItemClicked(in window: SFSafariWindow) {
    getActivePage { page in
      page?.dispatchMessageToScript(withName: "enablePiP", userInfo: nil)
    }
  }

  override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping (Bool, String) -> Void) {
    getActivePage {
      guard let page = $0 else {return}
      NSLog("INFO: videosFound: \(StateManager.shared.videosFound)")
      NSLog("INFO: video found: \(String(describing: StateManager.shared.videosFound[page]))")
      let videoFound = StateManager.shared.videosFound[page] ?? false
      NSLog("INFO: validating toolbarItem: \(videoFound)")
      validationHandler(videoFound, "")
    }
  }

  func getActivePage(completionHandler: @escaping (SFSafariPage?) -> Void) {
    SFSafariApplication.getActiveWindow { window in
      window?.getActiveTab { tab in
        tab?.getActivePage(completionHandler: completionHandler)
      }
    }
  }

  // MARK: - customPiPButton methods

  func pipCheck(callback: Any?) {
    NSLog("Is settings manager enabled: \(settingsManager.isCustomPiPButtonsEnabled)")
    guard settingsManager.isCustomPiPButtonsEnabled,
          let strongCallback = callback else { return }
    getActivePage { page in
      page?.dispatchMessageToScript(withName: "addCustomPiPButtonToPlayer", userInfo: ["callback": strongCallback])
    }
  }
}
