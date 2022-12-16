//
//  CommandOutputView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 3.12.2022.
//

import SwiftUI

struct CommandOutputView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    
    var body: some View {
        Text(barCatStore.outputLabel)
            .font(.footnote )
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }
}

struct CommandOutputView_Previews: PreviewProvider {
    static var previews: some View {
        CommandOutputView()
    }
}