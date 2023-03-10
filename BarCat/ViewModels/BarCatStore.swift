//
//  BarCatStore.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 6.10.2022.
//

import SwiftUI

class BarCatStore: ObservableObject {
    
    @Published var portCollection = PortCollection()
    @Published var hostCollection = HostCollection()
    
    // MARK: Host convenience variables
    
    var favoriteHosts: [Host] {
        get { self.hostCollection.favoriteHosts }
        set { self.hostCollection.favoriteHosts = newValue }
    }
    
    var sortedFavoriteHosts: [Host] {
        self.hostCollection.sortedFavoriteHosts
    }
    
    // MARK: Port convenience variables
    
    var ports: [Port] {
        self.portCollection.ports
    }
    
    var sortedPorts: [Port] {
        self.portCollection.sortedPorts
    }
    
    // MARK: Favorite hosts methods
    
    func selectedHostnames(for ids: Set<Host.ID>) -> String {
        hostCollection.selectedHostnames(for: ids)
    }
    
    func add(_ host: Host) {
        hostCollection.add(host)
    }
    
    func update(_ currentHost: Host, to newHost: Host) {
        hostCollection.update(currentHost, to: newHost)
    }
    
    func delete(_ hostIds: Set<Host.ID>) {
        hostCollection.delete(hostIds)
    }
    
    func favoriteHostsContainsPortThatWillBeDeleted(_ portId: Port.ID) -> Bool {
        hostCollection.favoriteHostsContainsPortThatWillBeDeleted(portId)
    }
    
    func validateInput(for host: Host) -> HostValidationStatus {
        hostCollection.hostValidator(host)
    }
    
    // MARK: Port methods
    
    func selectedPortNumber(for id: Port.ID) -> String {
        portCollection.selectedPortNumber(for: id)
    }
    
    func add(_ port: Port) {
        portCollection.add(port)
    }
    
    func deletePort(_ id: Port.ID) {
        portCollection.delete(id)
    }
    
    func validateInput(for port: Port) -> PortValidationStatus {
        portCollection.validateInput(for: port)
    }
}
