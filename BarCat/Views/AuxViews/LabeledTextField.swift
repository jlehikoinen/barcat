//
//  LabeledTextField.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 17.1.2023.
//

import SwiftUI

struct LabeledTextField: View {
    
    var label: String
    var placeholderText: String
    @Binding var text: String
    
    init(_ label: String, placeholderText: String, text: Binding<String>) {
        self.label = label
        self.placeholderText = placeholderText
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .captionSecondary()
            TextField(placeholderText, text: $text)
                .font(.system(size: 13, design: .monospaced))
        }
    }
}

struct LabeledTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabeledTextField("Test label", placeholderText: "Test placeholder", text: .constant("Test binding"))
    }
}
