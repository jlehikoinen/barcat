//
//  SettingsView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 7.11.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(AppPreferences.DefaultsTopLevelKey.netcatTimeoutKey.rawValue) var netcatTimeoutInSeconds: Int = Netcat.timeoutInSecs
    
    @State private var displayingEditFavoritesPopover = false
    @State private var displayingEditPortsPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            netCatTimeoutInput
            Divider()
                .foregroundColor(.purple)
            editFavoritesButton
            editPortsButton
            Divider()
                .foregroundColor(.purple)
            quitAppButton
        }
        .padding()
    }
    
    var netCatTimeoutInput: some View {
        HStack {
            Text("Netcat timeout (in seconds):")
            TextField("", value: $netcatTimeoutInSeconds, formatter: NumberFormatter())
                .frame(width: 50)
        }
        .padding(.horizontal)
    }
    
    var editFavoritesButton: some View {
        Button {
            displayingEditFavoritesPopover.toggle()
        } label: {
            Text("Edit favorites")
        }
        .popover(isPresented: $displayingEditFavoritesPopover) {
            FavoritesEditView()
                .frame(width: 360, height: 400)
                .padding()
        }
        .help("Edit favorites")
    }
    
    var editPortsButton: some View {
        Button {
            displayingEditPortsPopover.toggle()
        } label: {
            Text("Edit ports")
        }
        .popover(isPresented: $displayingEditPortsPopover) {
            PortsEditView()
                .frame(width: 320, height: 400)
                .padding()
        }
        .help("Edit Ports")
    }
    
    var quitAppButton: some View {
        Button("Quit BarCat") {
            NSApplication.shared.terminate(nil)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
