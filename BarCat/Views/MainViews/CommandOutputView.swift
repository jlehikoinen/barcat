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
        
        var outputText: String
        
        switch mainVM.commandState {
        case .notStarted: outputText = "..."
        case .loading: outputText = "Loading..."
        case .finishedSuccessfully: outputText = mainVM.outputLabel
        case .finishedWithError: outputText = mainVM.outputLabel
        }
        
        return Text(outputText)
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
