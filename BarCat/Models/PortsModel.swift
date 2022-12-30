//
//  PortsModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 19.12.2022.
//

import Foundation

struct PortsModel {
    
    let appPreferences = AppPreferences()
    
    var ports = [Port]()
    
    init() {
        readPorts()
    }
    
    // MARK: Computed properties
    
    var sortedPorts: [Port] {
        ports.sorted { $0.number < $1.number }
    }
    
    // MARK: CRUD methods
    
    mutating func readPorts() {
        
        if let ports: [Port] = appPreferences.read(forKey: AppPreferences.DefaultsObjectKey.ports) {
            self.ports = ports
        }
    }
    
    mutating func add(_ port: Port) {
        
        var newPort = port
        if newPort.description.isEmpty { newPort.description = "(no description)" }
        
        NSLog("Adding \(newPort)")
        ports.insert(newPort, at: 0)
        appPreferences.write(ports, forKey: AppPreferences.DefaultsObjectKey.ports)
    }
    
    mutating func delete(_ id: Port.ID) {
        
        if let index = ports.firstIndex(where: { $0.id == id} ) {
            NSLog("Deleting \(ports[index])")
            ports.remove(at: index)
            appPreferences.write(ports, forKey: AppPreferences.DefaultsObjectKey.ports)
        }
    }
    
    // MARK: Helper methods
    
    func selectedPortNumber(for id: Port.ID) -> String {
        
        var portNumber = ""
        
        if let index = ports.firstIndex(where: { $0.id == id } ) {
            portNumber = String(ports[index].number)
        }
        return portNumber
    }
    
    // MARK: Input validation
    
    func validateInput(for port: Port) -> PortValidationStatus {
        
//        NSLog("Port: \(port)")
//        NSLog("Duplicate: \(portsContains(port))")
//        NSLog("Valid number: \(port.isValidPortNumber)")
        
        // Note order
        if portsContains(port) { return .duplicate }
        if port.number == 0 { return .emptyPortNumber }
        if !port.isValidPortNumber { return .invalidPortNumber }
        
        return .valid
    }
    
    func portsContains(_ port: Port) -> Bool {
        self.ports.map { $0.number }.contains(port.number)
    }
}
