//
//  FavoritesEditViewModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 20.12.2022.
//

import Foundation

class FavoritesEditViewModel: ObservableObject {
    
    @Published var newHost = Host()
    @Published var debouncedNewHost = Host()
    
    //
    init() {
        // Delay text input
        $newHost
            .debounce(for: AppConfig.hostnameInputDelayInSeconds, scheduler: DispatchQueue.main)
            .assign(to: &$debouncedNewHost)
    }
}
