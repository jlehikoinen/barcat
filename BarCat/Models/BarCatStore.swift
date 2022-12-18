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
    @Published var favoriteHosts = [Host]()
    @Published var ports = [Port]()
    
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
        readPorts()
        
        // Delay text input
        $activeHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedActiveHost)
    
        $newHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedNewHost)
    }
    
    // MARK: Sorted objects
    
    public var sortedFavoriteHosts: [Host] {
        favoriteHosts.sorted { $0.nameAndPortAsString < $1.nameAndPortAsString }
    }
    
    public var sortedPorts: [Port] {
        ports.sorted { $0.number < $1.number }
    }
    
    func selectedHostnames(for hostIds: Set<Host.ID>) -> String {
        
        var hostnames = [String]()
        
        for id in hostIds {
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
        
        if let hosts: [Host] = appPreferences.read(forKey: AppPreferences.DefaultsObjectKey.FavoriteHosts) {
            self.favoriteHosts = hosts
        }
    }
    
    func add(_ host: Host) {
        
        NSLog("Adding \(host)")
        favoriteHosts.insert(host, at: 0)
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.FavoriteHosts)
        self.activeHost.validationStatus = .emptyHostname
    }
    
    func update(_ currentHost: Host, to newHost: Host) {
        
        // favoriteHosts will update anyway before this method is called
        // this method updates only host's validationStatus and if it's ok then defaults will be called
        
        NSLog("Updating \(currentHost.nameAndPortAsString) -> \(newHost.nameAndPortAsString)")
        
        if let index = favoriteHosts.firstIndex(where: { $0.id == newHost.id } ) {
            
            var host = newHost
            host.validationStatus = hostRowValidator(newHost)
            favoriteHosts[index] = host
            
            if host.validationStatus == .valid {
                appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.FavoriteHosts)
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
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.FavoriteHosts)
    }
    
    // MARK: Ports CRUD methods
    
    func readPorts() {
        
        if let ports: [Port] = appPreferences.read(forKey: AppPreferences.DefaultsObjectKey.Ports) {
            self.ports = ports
        }
    }
    
    func add(_ port: Port) {
        
        var newPort = port
        if newPort.description.isEmpty { newPort.description = "(no description)" }
        
        NSLog("Adding \(newPort)")
        ports.insert(newPort, at: 0)
        appPreferences.write(ports, forKey: AppPreferences.DefaultsObjectKey.Ports)
    }
    
    func delete(_ port: Port) {
        
        if let index = ports.firstIndex(where: { $0.id == port.id} ) {
            NSLog("Deleting \(port)")
            ports.remove(at: index)
            appPreferences.write(ports, forKey: AppPreferences.DefaultsObjectKey.Ports)
        }
    }
    
    // MARK: Public helper methods
    
    func favoriteHostsContainsPortThatWillBeDeleted(_ port: Port) -> Bool {
        !favoriteHosts.filter { $0.port == port }.isEmpty
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
        
        // Order?
        if favoriteHostsContains(host) {
            return .duplicate
        }
        
        if host.name.isEmpty {
            return .emptyHostname
        }
        
        if !host.isValidHostname {
            return .invalidHostname
        }
        
        return .valid
    }
    
    func hostRowValidator(_ host: Host) -> HostValidationStatus {
        
        NSLog("Host: \(host)")
        NSLog("Duplicate: \(favoriteHostsContainsDuplicates)")
        NSLog("Valid hostname: \(host.isValidHostname)")
        
        // Order?
        if favoriteHostsContainsDuplicates {
            return .duplicate
        }
        
        if host.name.isEmpty {
            return .emptyHostname
        }
        
        if !host.isValidHostname {
            return .invalidHostname
        }
        
        return .valid
    }
    
    func validateInput(for newPort: Port) -> PortValidationStatus {
        
//        NSLog("Port: \(newPort)")
//        NSLog("Duplicate: \(defaultPortsContains(newPort))")
//        NSLog("Valid number: \(newPort.isValidPortNumber)")
//        NSLog("Port valid for saving: \(self.isNewPortValid)")
        
        return portValidator(newPort)
    }
    
    private func portValidator(_ port: Port) -> PortValidationStatus {
        
        // Order?
        if portsContains(port) {
            return .duplicate
        }
        
        if !port.isValidPortNumber {
            return .invalidPortNumber
        }
        
        return .valid
    }
    
    // MARK: Duplicates
    
    // These are (temporarily) public because tests
    
    func favoriteHostsContains(_ host: Host) -> Bool {
        self.favoriteHosts.map { $0.nameAndPortAsString }.contains(host.nameAndPortAsString)
    }
    
    func portsContains(_ port: Port) -> Bool {
        self.ports.map { $0.number }.contains(port.number)
    }
    
    var favoriteHostsContainsDuplicates: Bool {
        Set(favoriteHosts.map { $0.nameAndPortAsString }).count != favoriteHosts.map { $0.nameAndPortAsString }.count
    }
}
