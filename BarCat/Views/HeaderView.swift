//
//  HeaderView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 7.11.2022.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("BarCat")
                    .font(.system(.title2, design: .rounded))
                    .foregroundStyle(AppStyle.headerTitleGradient)
                Text("Run netcat commands from menu bar")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
