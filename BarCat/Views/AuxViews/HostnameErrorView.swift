//
//  HostnameErrorView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 9.12.2022.
//

import SwiftUI

struct HostnameErrorView: View {
    
    let host: Host
    let location: ActiveHostLocation

    var body: some View {
        
        HStack {
            switch host.validationStatus {
            case .invalidHostname:
                Text(HostValidationStatus.invalidHostname.description)
                    .captionRed()
            case .duplicate:
                // Don't show duplicates in main view
                if location == .mainHostRowView {
                    Text(HostValidationStatus.duplicate.description)
                        .captionHidden()
                } else {
                    Text(HostValidationStatus.duplicate.description)
                        .captionRed()
                }
            case .emptyHostname:
                Text(HostValidationStatus.emptyHostname.description)
                    .captionHidden()
            case .valid:
                Text(HostValidationStatus.valid.description)
                    .captionHidden()
            case .none:
                Text(HostValidationStatus.emptyHostname.description)
                    .captionHidden()
            }
        }
    }
}

struct HostnameErrorView_Previews: PreviewProvider {
    static var previews: some View {
        HostnameErrorView(host: .sample, location: .mainHostRowView)
    }
}
