//
//  Command.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 31.12.2022.
//

import Foundation

struct Command {
    
    let exitCode: OSStatus
    let output: String
    
    init() {
        self.exitCode = 0
        self.output = ""
    }
    
    init(exitCode: OSStatus, output: String) {
        self.exitCode = exitCode
        self.output = output
    }
}
