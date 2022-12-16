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
        
        if !UserDefaults.standard.bool(forKey: AppPreferences.DefaultsTopLevelKey.firstLaunchDoneKey.rawValue)  {
            NSLog("First launch setup")
            appPreferences.write(Port.factoryTcpPorts, forKey: AppPreferences.DefaultsObjectKey.Ports)
            appPreferences.write(Host.exampleHosts, forKey: AppPreferences.DefaultsObjectKey.FavoriteHosts)
            UserDefaults.standard.set(true, forKey: AppPreferences.DefaultsTopLevelKey.firstLaunchDoneKey.rawValue)
        }
    }
}
