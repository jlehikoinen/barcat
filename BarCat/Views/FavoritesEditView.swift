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
    @State private var displayingDeleteAlert = false
    @State private var selectedHostsIds = Set<Host.ID>()

    let newHostPublisher = PassthroughSubject<Host, Never>()
    
    var selectedHostnames: String {
        selectedHostsIds.map { barCatStore[$0].nameAndPortAsString }.joined(separator: ", ")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Edit Favorites")
                    .font(.title2)
                Spacer()
                Button {
                    displayDeleteAlert()
                    print("Selected hosts: \(selectedHostsIds)")
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(selectedHostsIds.isEmpty)
                .help("Delete host")
                .alert("Delete?", isPresented: $displayingDeleteAlert) {
                    Button("Delete", role: .destructive) { delete(selectedHostsIds) }
                    Button("Cancel", role: .cancel) { }
                } message : {
                    Text(selectedHostnames)
                }
            }
            
            favoriteHostsTable
            
            Divider()
                .foregroundColor(.purple)
            
            Text("Add a new host")
                .font(.title2)
                .padding()
            
            addNewHostRow
        }
        .onAppear {
            self.displaySortedHosts()
        }
    }
    
    var favoriteHostsTable: some View {
        
        Table($barCatStore.favoriteHosts, selection: $selectedHostsIds) {
            
            TableColumn("Hostname") { $host in
                VStack(alignment: .leading) {
                    TextField(Host.namePlaceholder, text: $host.name)
                        .sfMonoFont(.tableRow)
                        .onChange(of: host) { [host] willBeHost in
                            newHostPublisher.send(willBeHost)
                            barCatStore.update(host, to: willBeHost)
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
                Picker("Port", selection: $host.port) {
                    ForEach(barCatStore.sortedPorts, id: \.self) { port in
                        HStack {
                            Spacer()
                            Text(String(port.number))
                                .font(Font.custom("SF Mono", size: 12))
                                .tag(Port.ID?.some(port.id))
                        }
                    }
                }
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
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hostname")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField(Host.namePlaceholder, text: $barCatStore.newHost.name)
                        .sfMonoFont(.textFieldInput)
                        .onChange(of: barCatStore.newHost) { _ in
                            barCatStore.validateInput(for: barCatStore.newHost, in: .editFavoritesNewHostView)
                        }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Port")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    portPickerNew
                        .frame(width: 80, alignment: .trailing)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Add") {
                        saveNewHost()
                    }
                    .disabled(barCatStore.newHost.validationStatus != .valid)
                    .keyboardShortcut(.defaultAction)
                }
            }
            HostnameErrorView(host: barCatStore.debouncedNewHost, location: .editFavoritesNewHostView)
        }
    }
    
    var portPickerNew: some View {
        
        Picker("Port", selection: $barCatStore.newHost.port) {
            ForEach(barCatStore.sortedPorts, id: \.self) { port in
                HStack {
                    Spacer()
                    Text(String(port.number))
                        .font(Font.custom("SF Mono", size: 13))
                        .tag(Port.ID?.some(port.id))
                }
            }
        }
        .labelsHidden()
        .onChange(of: barCatStore.newHost.port) { _ in
            NSLog("\(barCatStore.newHost.port)")
            barCatStore.validateInput(for: barCatStore.newHost, in: .editFavoritesRowView)
        }
    }
    
    // MARK: View helper methods
    
    private func saveNewHost() {
        
        barCatStore.add(Host(id: UUID().uuidString,
                             name: barCatStore.newHost.name,
                             port: barCatStore.newHost.port
                            ))
        
        barCatStore.newHost.name = ""
    }
    
    private func displayDeleteAlert() {
        displayingDeleteAlert = true
    }
    
    private func delete(_ hosts: Set<Host.ID>) {
        barCatStore.delete(hosts)
    }
    
    private func displaySortedHosts() {
        barCatStore.favoriteHosts = barCatStore.sortedFavoriteHosts
    }
}

struct FavoritesEditView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesEditView()
    }
}
