//
//  HostsModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 19.12.2022.
//

import Foundation

struct HostsModel {
    
    let appPreferences = AppPreferences()
    
    var favoriteHosts = [Host]()
    
    init() {
        readFavoriteHosts()
    }
    
    // MARK: Computed properties
    
    var sortedFavoriteHosts: [Host] {
        favoriteHosts.sorted { $0.nameAndPortAsString < $1.nameAndPortAsString }
    }
    
    // MARK: Helper methods
    
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
    
    func favoriteHostsContainsPortThatWillBeDeleted(_ portId: Port.ID) -> Bool {
        !favoriteHosts.filter { $0.port.id == portId }.isEmpty
    }
    
    // MARK: CRUD methods
    
    mutating func readFavoriteHosts() {
        
        if let hosts: [Host] = appPreferences.read(forKey: AppPreferences.DefaultsObjectKey.favoriteHosts) {
            self.favoriteHosts = hosts
        }
    }
    
    mutating func add(_ host: Host) {
        
        NSLog("Adding \(host)")
        favoriteHosts.insert(host, at: 0)
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
    }
    
    mutating func update(_ currentHost: Host, to newHost: Host) {
        
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
    
    mutating func delete(_ hostIds: Set<Host.ID>) {
        
        for id in hostIds {
            if let index = favoriteHosts.firstIndex(where: { $0.id == id } ) {
                NSLog("Deleting \(favoriteHosts[index])")
                favoriteHosts.remove(at: index)
            }
        }
        appPreferences.write(favoriteHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
    }
    
    // MARK: Input validation
    
    func hostValidator(_ host: Host) -> HostValidationStatus {
        
        // Note order
        if favoriteHostsContainsActive(host) { return .duplicate }
        if host.name.isEmpty { return .emptyHostname }
        if !host.isValidHostname { return .invalidHostname }
        
        return .valid
    }
    
    func hostRowValidator(_ host: Host) -> HostValidationStatus {
        
        // Note order
        if favoriteHostsContainsDuplicate(host) { return .duplicate }
        if host.name.isEmpty { return .emptyHostname }
        if !host.isValidHostname { return .invalidHostname }
        
        return .valid
    }
    
    // MARK: Duplicates
    
    // These are (temporarily) public because tests
    
    func favoriteHostsContainsActive(_ host: Host) -> Bool {
        self.favoriteHosts.map { $0.nameAndPortAsString }.contains(host.nameAndPortAsString)
    }
    
    func favoriteHostsContainsDuplicate(_ host: Host) -> Bool {
        favoriteHosts.filter{ $0.nameAndPortAsString == host.nameAndPortAsString }.count > 1
    }
    
    // MARK: Host subscript
    
    subscript(hostId: Host.ID?) -> Host {
        get {
            if let hostId {
                return favoriteHosts.first(where: { $0.id == hostId }) ?? .empty
            }
            return .empty
        }

        set(newValue) {
            if let hostId {
                favoriteHosts[favoriteHosts.firstIndex(where: { $0.id == hostId })!] = newValue
            }
        }
    }
}
