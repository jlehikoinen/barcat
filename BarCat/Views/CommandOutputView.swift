//
//  CommandOutputView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 3.12.2022.
//

import SwiftUI

struct CommandOutputView: View {
    
    var outputText: String
    
    var body: some View {
        Text(outputText)
            .font(.footnote )
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }
}

struct CommandOutputView_Previews: PreviewProvider {
    static var previews: some View {
        CommandOutputView(outputText: "Sample output")
    }
}
