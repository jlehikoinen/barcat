//
//  ProcessUtility.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import Foundation

struct ProcessUtility {
    
    let appPreferences = AppPreferences()
    
    func runNetcat(hostname: String, portNumber: Int) async throws -> (OSStatus, String) {

        var commandArguments = Netcat.options + [String(appPreferences.netcatTimeoutInSecs)]
        commandArguments.append(hostname)
        commandArguments.append(String(portNumber))
        
        return try await self.run(command: Netcat.path, arguments: commandArguments)
    }
    
    // TODO: Make this more generic, now nc specific
    private func run(command: String, arguments: [String]) async throws -> (OSStatus, String) {
        
        NSLog("Command: \(command) \(arguments)")
        
        let process = Process()
        let stdErrPipe = Pipe()
        
        process.launchPath = command
        process.arguments = arguments
        process.standardError = stdErrPipe
        process.launch()
        process.waitUntilExit()
        let exitCode = process.terminationStatus
        
        // nc outputs also stdOut to stdErr
        let errData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
        let rawOutput = String(data: errData, encoding: .utf8) ?? ""
        
        NSLog("Command exit code: \(exitCode)")
        NSLog("Command output: \(rawOutput)")
        
        let output = convertRawOutputToHumanFriendlyFormat(text: rawOutput)
        
        return (exitCode, output)
    }
    
    private func convertRawOutputToHumanFriendlyFormat(text: String) -> String {
        
        let uniqueRows = uniqueRowsFrom(text: text)
        return uniqueRows.joined(separator:"\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func uniqueRowsFrom(text: String) -> Set<String> {
        Set(text.components(separatedBy: "\n"))
    }
}
