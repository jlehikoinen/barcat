//
//  HostValidationStatus.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 14.12.2022.
//

import Foundation

enum HostValidationStatus: Codable {
    
    case duplicate
    case emptyHostname
    case invalidHostname
    case valid
    
    var description: String {
        
        switch self {
        case .duplicate: return "Duplicate host"
        case .emptyHostname: return "Hostname missing"
        case .invalidHostname: return "Invalid hostname"
        case .valid: return "Valid host"
        }
    }
}
