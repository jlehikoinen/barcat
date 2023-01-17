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
    
    @Published var isHostAnimating = false
    
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
    
    func animateHostInputFields() {
        
        withAnimation(Animation.easeIn(duration: 0.2)) {
            self.isHostAnimating.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.easeOut(duration: 0.2)) {
                self.isHostAnimating.toggle()
            }
        }
    }
}
