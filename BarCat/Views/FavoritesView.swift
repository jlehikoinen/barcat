//
//  FavoritesView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    @State private var selectedHost: Host.ID?
    
    var body: some View {
        HStack {
            favoriteHostsPicker
            addFavoriteHostButton
        }
    }
    
    var favoriteHostsPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Favorites")
                .font(.caption)
                .foregroundColor(.secondary)
            Picker("Favorites", selection: $selectedHost) {
                Text("...").tag(Host.ID?.none)
                ForEach(barCatStore.sortedFavoriteHosts, id: \.self) { host in
                    Text(host.nameAndPortAsString)
                        .font(Font.custom("SF Mono", size: 12))
                        .tag(Host.ID?.some(host.id))
                }
            }
            .labelsHidden()
            .onChange(of: selectedHost) { host in
                NSLog("Picker selection: \(String(describing: selectedHost))")
                barCatStore.updateActiveHostWithFavoritesPickerSelection(hostId: selectedHost)
            }
            .disabled(barCatStore.commandState == .loading)
        }
    }
    
    var addFavoriteHostButton: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("")
                .font(.caption)
                .foregroundColor(.secondary)
            Button {
                addNewFavoriteHost()
            } label: {
                Image(systemName: "plus")
            }
            .help("Add current host to favorites")
            .disabled(!barCatStore.activeHost.isValidHostname)
        }
    }
    
    // MARK: View helper methods
    
    private func addNewFavoriteHost() {
        
        barCatStore.add(Host(id: UUID().uuidString,
                             name: barCatStore.activeHost.name,
                             port: barCatStore.activeHost.port))
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
