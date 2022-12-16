//
//  PortValidationStatus.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 15.12.2022.
//

import Foundation

enum PortValidationStatus: Codable {
    
    case duplicate
    // case emptyPortNumber
    case invalidPortNumber
    case noError
    
    var description: String {
        
        switch self {
        case .duplicate: return "Duplicate port"
        case .invalidPortNumber: return "Invalid port number"
        case .noError: return "No error"
        }
    }
}
