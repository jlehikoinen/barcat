//
//  PortValidationStatus.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 15.12.2022.
//

import Foundation

enum PortValidationStatus: Codable {
    
    case duplicate
    case emptyPortNumber
    case invalidPortNumber
    case valid
    
    var description: String {
        
        switch self {
        case .duplicate: return "Duplicate port"
        case .emptyPortNumber: return "Empty port number"
        case .invalidPortNumber: return "Invalid port number"
        case .valid: return "Valid port"
        }
    }
}
