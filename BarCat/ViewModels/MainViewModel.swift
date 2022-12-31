//
//  MainViewModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.12.2022.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var activeHost = Host()
    @Published var debouncedActiveHost = Host()
    
    @Published var commandState: CommandState = .notStarted
    @Published var outputLabel: String = ""
    
    init() {
        // Delay text input
        $activeHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedActiveHost)
    }
    
    // MARK: View helper methods
    
    func resetCommandOutputLabel() {
        withAnimation(.default) {
            self.commandState = .notStarted
        }
    }
}
