//
//  Command.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 31.12.2022.
//

import Foundation

struct Command {
    
    let exitCode: OSStatus
    var output: String
    var state: CommandState
    
    init() {
        self.exitCode = 0
        self.output = ""
        self.state = .notStarted
    }
    
    init(exitCode: OSStatus, output: String) {
        self.exitCode = exitCode
        self.output = output
        self.state = .notStarted
    }
}
