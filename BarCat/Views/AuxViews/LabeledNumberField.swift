//
//  LabeledNumberField.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 26.2.2023.
//

import SwiftUI

struct LabeledNumberField: View {
    
    var label: String
    var placeholderText: String
    @Binding var number: Int?
    
    init(_ label: String, placeholderText: String, number: Binding<Int?>) {
        self.label = label
        self.placeholderText = placeholderText
        self._number = number
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .captionSecondary()
            TextField(placeholderText, value: $number, format: .number)
                .font(.system(size: 13, design: .monospaced))
        }
    }
}

struct LabeledNumberField_Previews: PreviewProvider {
    static var previews: some View {
        LabeledNumberField("Test label", placeholderText: "Test placeholder", number: .constant(123))
    }
}
