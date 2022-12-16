//
//  CustomFont.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 16.12.2022.
//

import SwiftUI

struct SFMonoFont: ViewModifier {
    
    public enum TextStyle {
        case tableRow
        case textFieldInput
    }
    
    var textStyle: TextStyle
    
    func body(content: Content) -> some View {
        return content.font(.custom("SF Mono", size: size))
    }
    
    private var size: CGFloat {
        switch textStyle {
        case .tableRow:
            return 12
        case .textFieldInput:
            return 13
        }
    }
}

extension View {
    
    func sfMonoFont(_ textStyle: SFMonoFont.TextStyle) -> some View {
        self.modifier(SFMonoFont(textStyle: textStyle))
    }
}
