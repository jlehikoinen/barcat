//
//  CaptionRed.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 9.12.2022.
//

import SwiftUI

struct CaptionRed: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.red)
    }
}

extension View {
    func captionRed() -> some View {
        modifier(CaptionRed())
    }
}
