//
//  CommandState.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 7.10.2022.
//

import SwiftUI

enum CommandState {
    
    case notStarted
    case loading
    case finishedSuccessfully
    case finishedWithError
    
    var highlightColor: Color {
        switch self {
        case .notStarted:
            return Color(NSColor.darkGray)
        case .loading:
            return .clear
        case .finishedSuccessfully:
            return .green
        case .finishedWithError:
            return .red
        }
    }
}
