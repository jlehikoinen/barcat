//
//  BarCatApp.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import SwiftUI

@main
struct BarCatApp: App {
    
    @StateObject var barCatStore = BarCatStore()
    private var appState = AppState()
    
    init() {
        appState.handleFirstLaunch()
    }
    
    var body: some Scene {
        MenuBarExtra("BarCat", systemImage: "pawprint.circle") {
            MenuBarWindowView()
                .environmentObject(barCatStore)
                .frame(minWidth: 350,
                       maxWidth: 350,
                       minHeight: 260,
                       maxHeight: 260)
        }
        .menuBarExtraStyle(.window)
    }
}
