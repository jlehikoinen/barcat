//
//  AppStyle.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 7.12.2022.
//

import SwiftUI

struct AppStyle {
    
    static let headerTitleGradient = LinearGradient(colors: [.accentColor, .blue.opacity(0.7)],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
    
    static let bgGradient = LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing)
}
