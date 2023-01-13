//
//  MainView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import SwiftUI

struct MainView: View {
    
    // MainViewModel is used for transferring data between these views
    @StateObject var mainVM: MainViewModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MainHostInputView(mainVM: mainVM)
            CommandOutputView(mainVM: mainVM)
            Divider()
                .foregroundColor(.purple)
            FavoritesView(mainVM: mainVM)
        }
        .padding()
        .onAppear {
            mainVM.resetCommandOutputLabel()
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
