//
//  CommandOutputView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 3.12.2022.
//

import SwiftUI

struct CommandOutputView: View {
    
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        
        var output: String
        
        switch mainVM.command.state {
        case .notStarted: output = "..."
        case .loading: output = "Loading..."
        case .finishedSuccessfully: output = mainVM.command.output
        case .finishedWithError: output = mainVM.command.output
        }
        
        return Text(output)
            .font(.footnote )
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
    }
}

struct CommandOutputView_Previews: PreviewProvider {
    static var previews: some View {
        CommandOutputView(mainVM: MainViewModel())
    }
}
