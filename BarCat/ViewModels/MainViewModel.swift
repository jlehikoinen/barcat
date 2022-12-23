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
    
}
