//
//  HostnameRowErrorView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 17.12.2022.
//

import SwiftUI

struct HostnameRowErrorView: View {
    
    let host: Host
    
    var body: some View {
        
        HStack {
            switch host.validationStatus {
            case .invalidHostname:
                Text(HostValidationStatus.invalidHostname.description)
                    .captionRed()
            case .duplicate:
                Text(HostValidationStatus.duplicate.description)
                    .font(.caption)
            case .emptyHostname:
                Text(HostValidationStatus.emptyHostname.description)
                    .captionRed()
            case .valid:
                EmptyView()
            case .none:
                EmptyView()
            }
        }
    }
}

struct HostnameRowErrorView_Previews: PreviewProvider {
    static var previews: some View {
        HostnameRowErrorView(host: .sample)
    }
}
