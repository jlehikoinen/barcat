//
//  BarCatStore.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 6.10.2022.
//

import SwiftUI

class BarCatStore: ObservableObject {
    
    @Published var portsModel = PortsModel()
    @Published var hostsModel = HostsModel()
    
    // MARK: Host convenience variables
    
    var favoriteHosts: [Host] {
        get { self.hostsModel.favoriteHosts }
        set { self.hostsModel.favoriteHosts = newValue }
    }
    
    var sortedFavoriteHosts: [Host] {
        self.hostsModel.sortedFavoriteHosts
    }
    
    // MARK: Port convenience variables
    
    var ports: [Port] {
        self.portsModel.ports
    }
    
    var sortedPorts: [Port] {
        self.portsModel.sortedPorts
    }
    
    // MARK: Favorite hosts methods
    
    func selectedHostnames(for ids: Set<Host.ID>) -> String {
        hostsModel.selectedHostnames(for: ids)
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
        hostsModel.favoriteHostsContainsPortThatWillBeDeleted(portId)
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
        portsModel.validateInput(for: port)
    }
}
