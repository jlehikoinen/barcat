//
//  AppState.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 28.11.2022.
//

import SwiftUI

class AppState: ObservableObject {
    
    let appPreferences = AppPreferences()
    
    func handleFirstLaunch() {
        
        NSLog("Launching app.")
        
        if !UserDefaults.standard.bool(forKey: AppPreferences.DefaultsTopLevelKey.firstLaunchDone.rawValue)  {
            NSLog("First launch setup")
            appPreferences.write(Port.factoryTcpPorts, forKey: AppPreferences.DefaultsObjectKey.ports)
            appPreferences.write(Host.exampleHosts, forKey: AppPreferences.DefaultsObjectKey.favoriteHosts)
            UserDefaults.standard.set(true, forKey: AppPreferences.DefaultsTopLevelKey.firstLaunchDone.rawValue)
        }
    }
}
