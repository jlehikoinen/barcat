//
//  MainView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MainHostInputView()
            CommandOutputView()
            Divider()
                .foregroundColor(.purple)
            FavoritesView()
        }
        .padding()
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
