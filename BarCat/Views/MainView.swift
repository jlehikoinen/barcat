//
//  MainView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var mainVM: MainViewModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MainHostInputView(mainVM: mainVM)
            CommandOutputView()
            Divider()
                .foregroundColor(.purple)
            FavoritesView(mainVM: mainVM)
        }
        .padding()
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
