//
//  AppPreferences.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 18.11.2022.
//

import Foundation
 
struct AppPreferences {
    
    // Custom compilation condition
    // See Build Settings > Swift Compiler - Custom Flags > Active Compilation Conditions
    #if TESTING
    let defaults = UserDefaults(suiteName: #file)!
    #else
    let defaults = UserDefaults.standard
    #endif
    
    enum DefaultsObjectKey: String {
        case favoriteHosts = "FavoriteHosts"
        case ports = "Ports"
    }
    
    enum DefaultsTopLevelKey: String {
        case firstLaunchDone = "FirstLaunchDone"
        case netcatTimeout = "NetcatTimeoutInSeconds"
    }
    
    // There's also @AppStorage var in SettingsView
    // This is for accessing defaults' value outside Views
    var netcatTimeoutInSecs: Int { return defaults.integer(forKey: AppPreferences.DefaultsTopLevelKey.netcatTimeout.rawValue) }
    
    // MARK: Methods
    
    func read<T: Codable>(forKey key: DefaultsObjectKey) -> T? {
        
        #if TESTING
        NSLog("Reading \(T.Type.self) from TEST UserDefaults")
        #else
        NSLog("Reading \(T.Type.self) from UserDefaults")
        #endif
        
        if let json = defaults.data(forKey: key.rawValue) {
            do {
                return try JSONDecoder().decode(T.self, from: json)
            } catch {
                NSLog("Decoding error (\(T.Type.self)): \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func write<T: Codable>(_ object: T, forKey key: DefaultsObjectKey) {
        
        #if TESTING
        NSLog("Writing \(T.Type.self) to TEST UserDefaults")
        #else
        NSLog("Writing \(T.Type.self) to UserDefaults")
        #endif
        
        do {
            let encodedObject = try JSONEncoder().encode(object)
            defaults.set(encodedObject, forKey: key.rawValue)
        } catch {
            NSLog("Encoding error (\(T.Type.self)): \(error.localizedDescription)")
        }
    }
}
