//
//  PortsEditViewModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 20.12.2022.
//

import Foundation

class PortsEditViewModel: ObservableObject {
    
    @Published var newPort = Port()
    @Published var debouncedNewPort = Port()
    @Published var portNumber: Int?
    
    init() {
        // Delay text input
        $newPort
            .debounce(for: AppConfig.portInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedNewPort)
    }
}
