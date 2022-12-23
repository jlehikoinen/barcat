//
//  FavoritesView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    @ObservedObject var mainVM: MainViewModel
    @State var selectedHostId: Host.ID?
    
    var body: some View {
        HStack {
            favoriteHostsPicker
            addFavoriteHostButton
        }
    }
    
    var favoriteHostsPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Favorites")
                .captionSecondary()
            Picker("Favorites", selection: $selectedHostId) {
                Text("...").tag(Host.ID?.none)
                ForEach(barCatStore.sortedFavoriteHosts, id: \.self) { host in
                    Text(host.nameAndPortAsString)
                        .font(Font.custom("SF Mono", size: 12))
                        .tag(Host.ID?.some(host.id))
                }
            }
            .labelsHidden()
            .onChange(of: selectedHostId) { host in
                NSLog("Picker selection: \(String(describing: selectedHostId))")
                mainVM.activeHost = barCatStore.hostsModel[selectedHostId]
            }
            .disabled(mainVM.commandState == .loading)
        }
    }
    
    var addFavoriteHostButton: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("")
                .captionSecondary()
            Button {
                addNewFavoriteHost()
            } label: {
                Image(systemName: "plus")
            }
            .help("Add current host to favorites")
            .disabled(!mainVM.activeHost.isValidHostname)
        }
    }
    
    // MARK: View helper methods
    
    private func addNewFavoriteHost() {
        
        barCatStore.add(Host(id: UUID().uuidString,
                             name: mainVM.activeHost.name,
                             port: mainVM.activeHost.port))
        
        mainVM.activeHost.validationStatus = .emptyHostname
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(mainVM: MainViewModel())
    }
}
