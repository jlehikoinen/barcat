//
//  Host.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import Foundation
import SwiftUI

struct Host {
    
    var id: String
    var name: String
    var port: Port
    var validationStatus: HostValidationStatus?
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.port = Port.default
    }
    
    init(id: String, name: String, port: Port) {
        self.id = id
        self.name = name
        self.port = port
    }
}

extension Host: Identifiable {}
extension Host: Hashable {}
extension Host: Codable {}

// MARK: Computed vars

extension Host {
    
    var nameAndPortAsString: String {
        "\(name) : \(port.number)"
    }
    
    var isValidHostname: Bool {
        // Compromise between IP address & FQDN
        let pattern = /[\w-]+\.[\w\.-]+[a-zA-Z0-9]$/
        return self.name.starts(with: pattern)
    }
}

// MARK: Placeholders

extension Host {
    
    static let namePlaceholder = "hs.fi / 1.1.1.1"
}

// MARK: Sample data

extension Host {
    
    static var sample = Host(id: UUID().uuidString, name: "il.fi", port: Port.sample)
}

// MARK: Examples

extension Host {
    
    static let exampleHosts = [
        Host(id: UUID().uuidString, name: "1.1.1.1", port: Port(id: "00000000-0000-0000-0000-000000000080", number: 80, description: "http")),
        Host(id: UUID().uuidString, name: "il.fi", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https")),
        Host(id: UUID().uuidString, name: "is.fi", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https"))
    ]
}
