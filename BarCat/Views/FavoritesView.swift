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
    @State private var selectedHostId: Host.ID?
    @State private var isPickerBorderVisible = false
    
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
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.green, lineWidth: isPickerBorderVisible ? 2 : 1)
                    .opacity(isPickerBorderVisible ? 1 : 0)
            )
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
            .disabled(!mainVM.activeHost.isValidHostname || mainVM.commandState == .loading)
        }
    }
    
    // MARK: View helper methods
    
    private func addNewFavoriteHost() {
        
        animatePickerBorder()
        
        barCatStore.add(Host(id: UUID().uuidString,
                             name: mainVM.activeHost.name,
                             port: mainVM.activeHost.port))
        
        mainVM.activeHost.validationStatus = .emptyHostname
    }
    
    private func animatePickerBorder() {
        
        withAnimation(Animation.easeIn(duration: 0.2)) {
            isPickerBorderVisible.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.linear(duration: 0.4)) {
                isPickerBorderVisible.toggle()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(mainVM: MainViewModel())
    }
}
