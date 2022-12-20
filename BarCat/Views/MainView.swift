//
//  MainView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    
    @State private var selectedHostId: Host.ID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MainHostInputView(inputHost: selectedHost)
            CommandOutputView()
            Divider()
                .foregroundColor(.purple)
            FavoritesView(selectedHost: selection)
        }
        .padding()
    }
    
    private var selection: Binding<Host.ID?> {
        Binding(get: { selectedHostId ?? "" }, set: { selectedHostId = $0 })
    }
    
    private var selectedHost: Binding<Host> {
        // TODO: Change to subscript
        $barCatStore.activeHost
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
