//
//  Port.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 25.11.2022.
//

import Foundation

struct Port {
    
    var id: String
    var number: Int
    var description: String
    var validationStatus: PortValidationStatus?
    
    init() {
        self.id = UUID().uuidString
        self.number = 1
        self.description = ""
    }
    
    init(id: String, number: Int, description: String) {
        self.id = id
        self.number = number
        self.description = description
    }
    
    static func < (lhs: Port, rhs: Port) -> Bool {
        lhs.number < rhs.number
    }
}

extension Port: Identifiable {}
extension Port: Hashable {}
extension Port: Codable {}
extension Port: Comparable {}

// MARK: Computed vars

extension Port {
    
    var isValidPortNumber: Bool {
        Port.portNumberRange ~= number
    }
}

// MARK: Constants

extension Port {
    
    static let portNumberRange: ClosedRange = 1...65535
    static let reservedPortNumberRange: ClosedRange = 1...1023
    static let userPortNumberRange: ClosedRange = 1024...65535
    static let defaultPortNumber = 443
    static let defaultPort = Port(id: factoryHttpsPortUuid, number: 443, description: "https")
}

// MARK: Factory ports

extension Port {
    
    static let factoryHttpsPortUuid = "00000000-0000-0000-0000-000000000443"
    
    static let factoryTcpPorts = [
        Port(id: "00000000-0000-0000-0000-000000000022", number: 22, description: "ssh"),
        Port(id: "00000000-0000-0000-0000-000000000080", number: 80, description: "http"),
        Port(id: factoryHttpsPortUuid, number: 443, description: "https"),
        Port(id: "00000000-0000-0000-0000-000000000445", number: 445, description: "smb"),
        Port(id: "00000000-0000-0000-0000-000000005223", number: 5223, description: "APNs client"),
        Port(id: "00000000-0000-0000-0000-000000005900", number: 5900, description: "vnc"),
        Port(id: "00000000-0000-0000-0000-000000008443", number: 8443, description: "custom https"),
        Port(id: "00000000-0000-0000-0000-000000010443", number: 10443, description: "custom https")
    ]
}

// MARK: Sample data

extension Port {
    
    static var `default` = Self.init(id: Port.factoryHttpsPortUuid, number: 443, description: "https")
    static var sample = Self.init(id: UUID().uuidString, number: 80, description: "http")
}
