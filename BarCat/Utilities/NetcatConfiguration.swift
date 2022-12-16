//
//  NetcatConfiguration.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 9.12.2022.
//

import Foundation

enum Netcat {
    
    static let path = "/usr/bin/nc"
    static let options = ["-v", "-z", "-G"]
    static let timeoutInSecs = 1
}
