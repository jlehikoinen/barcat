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
                if location == .mainHostRowView {
                    EmptyView()
                } else {
                    Text(HostValidationStatus.duplicate.description)
                        .font(.caption)
                }
            case .emptyHostname:
                EmptyView()
                // Text(HostError.emptyHostname.description)
                // .captionRed()
            case .noError:
                EmptyView()
            case .none:
                EmptyView()
            }
        }
    }
}

struct HostnameErrorView_Previews: PreviewProvider {
    static var previews: some View {
        HostnameErrorView(host: .sample, location: .mainHostRowView)
    }
}
