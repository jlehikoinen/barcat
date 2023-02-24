//
//  Host.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import Foundation

struct Host {
    
    var id: String
    var name: String
    var port: Port
    var validationStatus: HostValidationStatus?
}

extension Host: Identifiable {}
extension Host: Hashable {}
extension Host: Codable {}
extension Host: Comparable {}

extension Host {
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.port = Port.default
    }
}

extension Host {
    
    static func < (lhs: Host, rhs: Host) -> Bool {
        lhs.nameAndPortNumber < rhs.nameAndPortNumber
    }
}

// MARK: Computed vars

extension Host {
    
    var nameAndPortNumber: String {
        "\(name) : \(port.number)"
    }
    
    var isValidHostname: Bool {
        // Compromise between IP address & FQDN
        let pattern = /[\w-]+\.[\w\.-]+[a-zA-Z0-9]$/
        return self.name.starts(with: pattern)
    }
    
    var wrappedValidationStatus: HostValidationStatus {
        validationStatus ?? .invalidHostname
    }
}

// MARK: Placeholders

extension Host {
    
    static let namePlaceholder = "domain.tld / 1.1.1.1"
}

// MARK: Sample data

extension Host {
    
    static var sample = Host(id: UUID().uuidString, name: "google.com", port: Port.sample)
    static var empty = Host(id: UUID().uuidString, name: "", port: Port.default)
}

// MARK: Examples

extension Host {
    
    static let exampleHosts = [
        Host(id: UUID().uuidString, name: "1.1.1.1", port: Port(id: "00000000-0000-0000-0000-000000000080", number: 80, description: "http")),
        Host(id: UUID().uuidString, name: "50-courier.push.apple.com", port: Port(id: "00000000-0000-0000-0000-000000005223", number: 5223, description: "APNs client")),
        Host(id: UUID().uuidString, name: "google.com", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https")),
        Host(id: UUID().uuidString, name: "wikipedia.org", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https"))
    ]
}
