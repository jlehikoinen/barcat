//
//  MenuBarWindowView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 18.11.2022.
//

import SwiftUI

struct MenuBarWindowView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView()
            Divider()
                .foregroundColor(.accentColor)
            HeaderTabView()
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarWindowView()
    }
}
