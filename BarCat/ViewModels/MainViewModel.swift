//
//  MainViewModel.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 22.12.2022.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var selectedHostId: Host.ID?
    
    var selection: Binding<Host.ID?> {
        Binding(get: { self.selectedHostId }, set: { self.selectedHostId = $0 })
    }
}
