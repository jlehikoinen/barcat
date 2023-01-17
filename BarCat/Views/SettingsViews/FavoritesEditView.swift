//
//  FavoritesEditView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 9.11.2022.
//

import Combine
import SwiftUI

struct FavoritesEditView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    @ObservedObject var favoritesEditVM = FavoritesEditViewModel()
    
    @State private var displayingDeleteAlert = false
    @State private var selectedHostIds = Set<Host.ID>()

    let newHostPublisher = PassthroughSubject<Host, Never>()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Edit Favorites")
                    .font(.title2)
                Spacer()
                deleteButton
            }
            .padding(.trailing)
            
            favoriteHostsTable
            
            Divider()
                .foregroundColor(.purple)
            
            Text("Add a new host")
                .font(.title2)
                .padding(.vertical)
            
            addNewHostRow
        }
        .onAppear {
            self.displaySortedHosts()
        }
    }
    
    var deleteButton: some View {
        
        Button {
            displayDeleteAlert()
            NSLog("Selected hosts: \(selectedHostIds)")
        } label: {
            Image(systemName: "trash")
        }
        .disabled(selectedHostIds.isEmpty)
        .help("Delete host")
        .alert("Delete these hosts?", isPresented: $displayingDeleteAlert) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    delete(selectedHostIds)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message : {
            Text(barCatStore.selectedHostnames(for: selectedHostIds))
        }
    }
    
    var favoriteHostsTable: some View {
        
        Table($barCatStore.favoriteHosts, selection: $selectedHostIds) {
            
            TableColumn("Hostname") { $host in
                VStack(alignment: .leading) {
                    TextField(Host.namePlaceholder, text: $host.name)
                        .font(.system(size: 12, design: .monospaced))
                        .onChange(of: host) { [host] newHost in
                            newHostPublisher.send(newHost)
                            barCatStore.update(host, to: newHost)
                        }
                        // How to identify row being edited for debouncedHost?
                        .onReceive(newHostPublisher
                            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
                        ) { debouncedHost in
                            // print(debouncedHost)
                        }
                        .help(host.name)
                        .padding(.vertical, 4)
                    HostnameRowErrorView(host: host)
                }
            }
            .width(min: 180, ideal: 180, max: 200)
            
            TableColumn("Port") { $host in
                PortPicker(selectedPort: $host.port, ports: barCatStore.sortedPorts)
                .labelsHidden()
                .frame(width: 80, alignment: .trailing)
                .onChange(of: host.port) { _ in
                    NSLog("\(host.port)")
                }
            }
            .width(min: 100, ideal: 100, max: 120)
        }
    }
    
    var addNewHostRow: some View {
        
        VStack(alignment: .leading) {
            HStack {
                LabeledTextField("Hostname", placeholderText: Host.namePlaceholder, text: $favoritesEditVM.newHost.name)
                    .onChange(of: favoritesEditVM.newHost) { _ in
                        favoritesEditVM.newHost.validationStatus = barCatStore.validateInput(for: favoritesEditVM.newHost)
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Port")
                        .captionSecondary()
                    PortPicker(selectedPort: $favoritesEditVM.newHost.port, ports: barCatStore.sortedPorts)
                        .labelsHidden()
                        .onChange(of: favoritesEditVM.newHost.port) { _ in
                            NSLog("\(favoritesEditVM.newHost.port)")
                            favoritesEditVM.newHost.validationStatus = barCatStore.validateInput(for: favoritesEditVM.newHost)
                        }
                        .frame(width: 80, alignment: .trailing)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("")
                        .captionSecondary()
                    Button("Add") {
                        withAnimation {
                            saveNewHost()
                        }
                    }
                    .disabled(favoritesEditVM.newHost.validationStatus != .valid)
                    .keyboardShortcut(.defaultAction)
                }
            }
            HostnameErrorView(host: favoritesEditVM.debouncedNewHost, location: .editFavoritesNewHostView)
        }
    }
    
    // MARK: View helper methods
    
    private func saveNewHost() {
        
        barCatStore.add(Host(id: UUID().uuidString,
                             name: favoritesEditVM.newHost.name,
                             port: favoritesEditVM.newHost.port
                            ))
        
        favoritesEditVM.newHost.name = ""
    }
    
    private func displayDeleteAlert() {
        displayingDeleteAlert = true
    }
    
    private func delete(_ hosts: Set<Host.ID>) {
        barCatStore.delete(hosts)
    }
    
    /// Use this ad-hoc sorting method when view loads
    /// List of hosts is not sorted by default so when adding a new host the host appears on top of the list
    private func displaySortedHosts() {
        barCatStore.favoriteHosts.sort()
    }
}

struct FavoritesEditView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesEditView()
    }
}
