//
//  HeaderTabView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 18.11.2022.
//

import SwiftUI

struct HeaderTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "pawprint.circle")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct HeaderTabView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderTabView()
    }
}
