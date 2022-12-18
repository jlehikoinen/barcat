//
//  PortErrorView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 17.12.2022.
//

import SwiftUI

struct PortErrorView: View {
    
    let port: Port
    
    var body: some View {
        
        let _ = print(port)
        
        HStack {
            switch port.validationStatus {
            case .duplicate:
                Text(PortValidationStatus.duplicate.description)
                    .captionRed()
            case .emptyPortNumber:
                Text(PortValidationStatus.emptyPortNumber.description)
                    .captionHidden()
            case .invalidPortNumber:
                Text(PortValidationStatus.invalidPortNumber.description)
                    .captionRed()
            case .valid:
                Text(PortValidationStatus.valid.description)
                    .captionHidden()
            case .none:
                Text(PortValidationStatus.emptyPortNumber.description)
                    .captionHidden()
            }
        }
    }
}

struct PortErrorView_Previews: PreviewProvider {
    static var previews: some View {
        PortErrorView(port: .sample)
    }
}
