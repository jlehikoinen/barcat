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
                .frame(minWidth: 380,
                       maxWidth: 380,
                       minHeight: 280,
                       maxHeight: 280)
        }
        .menuBarExtraStyle(.window)
    }
}
