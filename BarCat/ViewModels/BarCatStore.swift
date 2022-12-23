//
//  BarCatStore.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 6.10.2022.
//

import SwiftUI

class BarCatStore: ObservableObject {
    
    //
    let appPreferences = AppPreferences()
    
    //
    @Published var portsModel = PortsModel()
    @Published var hostsModel = HostsModel()
    
    @Published var stateHighlightColor: Color = .clear
    @Published var commandState: CommandState = .notStarted
    @Published var outputLabel: String = "..."
    
    // MARK: Host convenience variables
    
    var favoriteHosts: [Host] {
        get { self.hostsModel.favoriteHosts }
        set { self.hostsModel.favoriteHosts = newValue }
    }
    
    var sortedFavoriteHosts: [Host] {
        favoriteHosts.sorted { $0.nameAndPortAsString < $1.nameAndPortAsString }
    }
    
    // MARK: Port convenience variables
    
    var ports: [Port] {
        self.portsModel.ports
    }
    
    var sortedPorts: [Port] {
        ports.sorted { $0.number < $1.number }
    }
    
    // MARK: View helper methods
    
    func resetHightlightAndCommandOutputLabel() {
        
        self.updateUIBasedOn(commandState: .notStarted,
                                           color: Color(NSColor.darkGray),
                                           message: "...")
    }
    
    func updateUIBasedOn(commandState: CommandState, color: Color, message: String) {
        
        withAnimation(.default) {
            self.commandState = commandState
            self.stateHighlightColor = color
            self.outputLabel = message
        }
    }
    
    // MARK: Favorite hosts methods
    
    func selectedHostnames(for ids: Set<Host.ID>) -> String {
        return hostsModel.selectedHostnames(for: ids)
    }
    
    func add(_ host: Host) {
        hostsModel.add(host)
    }
    
    func update(_ currentHost: Host, to newHost: Host) {
        hostsModel.update(currentHost, to: newHost)
    }
    
    func delete(_ hostIds: Set<Host.ID>) {
        hostsModel.delete(hostIds)
    }
    
    func favoriteHostsContainsPortThatWillBeDeleted(_ portId: Port.ID) -> Bool {
        return hostsModel.favoriteHostsContainsPortThatWillBeDeleted(portId)
    }
    
    func validateInput(for host: Host) -> HostValidationStatus {
        hostsModel.hostValidator(host)
    }
    
    // MARK: Port methods
    
    func selectedPortNumber(for id: Port.ID) -> String {
        portsModel.selectedPortNumber(for: id)
    }
    
    func add(_ port: Port) {
        portsModel.add(port)
    }
    
    func deletePort(_ id: Port.ID) {
        portsModel.delete(id)
    }
    
    func validateInput(for port: Port) -> PortValidationStatus {
        return portsModel.validateInput(for: port)
    }
}
