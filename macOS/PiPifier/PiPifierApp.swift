//
//  PiPifierApp.swift
//  PiPifier
//
//  Created by Oleksandr Skrypnyk on 6/23/21.
//  Copyright © 2021 Oleksandr Skrypnyk. All rights reserved.
//

import SwiftUI

@main
struct PiPifierApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var addDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: 480, minHeight: 340)
    }
  }
}
