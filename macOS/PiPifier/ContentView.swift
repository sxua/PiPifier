//
//  ContentView.swift
//  PiPifier
//
//  Created by Oleksandr Skrypnyk on 6/23/21.
//  Copyright © 2021 Oleksandr Skrypnyk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var isToggleOn = SettingsManager.shared.isCustomPiPButtonsEnabled

  var body: some View {
    GeometryReader { geometry in
      VStack(alignment: .leading, spacing: 8) {
        Text("welcome".localized())
          .font(.system(size: 20))
          .frame(width: geometry.size.width)
          .padding(.top)
        Text("installation".localized())
          .padding(.init(top: 0, leading: 18, bottom: 0, trailing: 18))
        Text("instructions".localized())
          .padding(.init(top: 0, leading: 80, bottom: 0, trailing: 80))
          .lineSpacing(8)
        Text("settings".localized())
          .padding(.init(top: 0, leading: 18, bottom: 0, trailing: 18))
        Toggle("toggle".localized(), isOn: $isToggleOn)
          .padding(.init(top: 0, leading: 80, bottom: 8, trailing: 80))
          .onChange(of: isToggleOn) { newValue in
            SettingsManager.shared.isCustomPiPButtonsEnabled = newValue
          }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .frame(width: 480, height: 340)
  }
}
