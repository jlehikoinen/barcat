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
    
    //
    @Published var favoriteHosts = [Host]()
    
    @Published var activeHost = Host()
    @Published var debouncedActiveHost = Host()
    
    @Published var newHost = Host()
    @Published var debouncedNewHost = Host()
    
    @Published var stateHighlightColor: Color = .clear
    @Published var commandState: CommandState = .notStarted
    @Published var outputLabel: String = "..."
    
    //
    init() {
        
        readFavoriteHosts()
        portsModel.readPorts()
        
        // Delay text input
        $activeHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedActiveHost)
    
        $newHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedNewHost)
    }
    
    // MARK: Port convenience variables
    
    var ports: [Port] {
        self.portsModel.ports
    }
    
    var sortedPorts: [Port] {
        ports.sorted { $0.number < $1.number }
    }
    
    // MARK: Sorted objects
    
    var sortedFavoriteHosts: [Host] {
        favoriteHosts.sorted { $0.nameAndPortAsString < $1.nameAndPortAsString }
    }
    
    // MARK: Id matching
    
    func selectedHostnames(for ids: Set<Host.ID>) -> String {
        
        var hostnames = [String]()
        
        for id in ids {
            if let index = favoriteHosts.firstIndex(where: { $0.id == id } ) {
                hostnames.append(favoriteHosts[index].nameAndPortAsString)
            }
        }
        
        hostnames.sort()
        return hostnames.joined(separator: ", ")
    }
    
    // MARK: View helper methods
    
    func updateActiveHostWithFavoritesPickerSelection(hostId: Host.ID?) {
        
        if let id = hostId {
            self.activeHost = favoriteHosts.first(where: { $0.id == id })!
            self.resetHightlightAndCommandOutputLabel()
            self.activeHost.validationStatus = .emptyHostname
        }
    }
    
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
    
    // MARK: Favorite hosts CRUD methods
    
    func readFavoriteHosts() {
        
        if let hosts: [Host] = appPreferences.read(forKey: AppPreferences.DefaultsObjectKey.favoriteHosts) {
            self.favoriteHosts = hosts
        }
    }
    
    func add(_ host: Host) {
        
        NSLog("Adding \(host)")
        favoriteHosts.insert(host, at: 0)
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
        self.activeHost.validationStatus = .emptyHostname
    }
    
    func update(_ currentHost: Host, to newHost: Host) {
        
        // favoriteHosts will update anyway before this method is called
        // this method updates only host's validationStatus and if it's ok then defaults will be saved
        
        NSLog("Updating \(currentHost.nameAndPortAsString) -> \(newHost.nameAndPortAsString)")
        
        if let index = favoriteHosts.firstIndex(where: { $0.id == newHost.id } ) {
            
            var host = newHost
            host.validationStatus = hostRowValidator(newHost)
            favoriteHosts[index] = host
            
            if host.validationStatus == .valid {
                appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
            }
        }
    }
    
    func delete(_ hostIds: Set<Host.ID>) {
        
        for id in hostIds {
            if let index = favoriteHosts.firstIndex(where: { $0.id == id } ) {
                NSLog("Deleting \(favoriteHosts[index])")
                favoriteHosts.remove(at: index)
            }
        }
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
    }
    
    // MARK: Public helper methods
    
    func favoriteHostsContainsPortThatWillBeDeleted(_ portId: Port.ID) -> Bool {
        !favoriteHosts.filter { $0.port.id == portId }.isEmpty
    }
    
    // MARK: Input validation
    
    func validateInput(for host: Host, in location: ActiveHostLocation) {
        
        switch location {
        case .mainHostRowView:
            self.activeHost.validationStatus = hostValidator(host)
        case .editFavoritesRowView:
            // host row validation in update method
            fallthrough
        case .editFavoritesNewHostView:
            self.newHost.validationStatus = hostValidator(host)
        }
        
//        NSLog("Host: \(host)")
//        NSLog("Duplicate: \(favoriteHostsContains(host))")
//        NSLog("Valid hostname: \(host.isValidHostname)")
//        NSLog("Active host error type: \(String(describing: self.activeHost.validationStatus))")
//        NSLog("New host error type: \(String(describing: self.newHost.validationStatus))")
    }
    
    private func hostValidator(_ host: Host) -> HostValidationStatus {
        
        // Note order
        if favoriteHostsContains(host) { return .duplicate }
        if host.name.isEmpty { return .emptyHostname }
        if !host.isValidHostname { return .invalidHostname }
        
        return .valid
    }
    
    func hostRowValidator(_ host: Host) -> HostValidationStatus {
        
//        NSLog("Host: \(host)")
//        NSLog("Duplicate: \(favoriteHostsContainsDuplicates)")
//        NSLog("Valid hostname: \(host.isValidHostname)")
        
        // Note order
        if favoriteHostsContainsDuplicates { return .duplicate }
        if host.name.isEmpty { return .emptyHostname }
        if !host.isValidHostname { return .invalidHostname }
        
        return .valid
    }

    // MARK: Duplicates
    
    // These are (temporarily) public because tests
    
    func favoriteHostsContains(_ host: Host) -> Bool {
        self.favoriteHosts.map { $0.nameAndPortAsString }.contains(host.nameAndPortAsString)
    }
    
    var favoriteHostsContainsDuplicates: Bool {
        Set(favoriteHosts.map { $0.nameAndPortAsString }).count != favoriteHosts.map { $0.nameAndPortAsString }.count
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
