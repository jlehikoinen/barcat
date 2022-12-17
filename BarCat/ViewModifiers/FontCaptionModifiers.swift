//
//  FontCaptionModifiers.swift
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

struct CaptionHidden: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .opacity(0)
    }
}

extension View {
    
    func captionRed() -> some View {
        modifier(CaptionRed())
    }
    
    func captionHidden() -> some View {
        modifier(CaptionHidden())
    }
}
