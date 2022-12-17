//
//  MainHostInputView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import SwiftUI

struct MainHostInputView: View {
    
    let processUtility = ProcessUtility()
    
    @EnvironmentObject var barCatStore: BarCatStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                hostnameField
                portPicker
                runButton
            }
            HostnameErrorView(host: barCatStore.debouncedActiveHost, location: .mainHostRowView)
        }
    }
    
    var hostnameField: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Hostname")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField(Host.namePlaceholder, text: $barCatStore.activeHost.name)
                .sfMonoFont(.textFieldInput)
                .border(barCatStore.stateHighlightColor)
                .disabled(barCatStore.commandState == .loading)
                .onChange(of: barCatStore.activeHost) { host in
                    barCatStore.resetHightlightAndCommandOutputLabel()
                    barCatStore.validateInput(for: host, in: .mainHostRowView)
                }
        }
    }
    
    var portPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Port")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("Port", selection: $barCatStore.activeHost.port) {
                ForEach(barCatStore.sortedPorts, id: \.self) { port in
                    HStack {
                        Spacer()
                        Text(String(port.number))
                            .font(Font.custom("SF Mono", size: 13))
                            // .sfMonoFont(.textFieldInput)
                            .tag(Port.ID?.some(port.id))
                    }
                }
            }
            .onChange(of: barCatStore.activeHost.port) { selectedPort in
                NSLog("Port selected: \(selectedPort)")
                barCatStore.resetHightlightAndCommandOutputLabel()
            }
            .labelsHidden()
            .frame(width: 80, alignment: .trailing)
            .disabled(barCatStore.commandState == .loading)
        }
    }
    
    var runButton: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button {
                Task {
                    await runNetcat()
                }
            } label: {
                Text("Run")
            }
            .disabled(barCatStore.commandState == .loading || !barCatStore.activeHost.isValidHostname)
            .keyboardShortcut(.defaultAction)
        }
    }
    
    // MARK: View helper methods
    
    private func runNetcat() async {
        
        var exitCode: OSStatus = 0
        var output = ""
        
        barCatStore.updateUIBasedOn(commandState: .loading,
                                    color: .clear,
                                    message: "Loading...")
        
        do {
            (exitCode, output) = try await processUtility.runNetcat(hostname: barCatStore.activeHost.name,
                                                                    portNumber: barCatStore.activeHost.port.number)
        } catch {
            NSLog("Error: Command failed")
            exitCode = 1
        }
        
        if exitCode == 0 {
            barCatStore.updateUIBasedOn(commandState: .finishedSuccessfully,
                                        color: .green,
                                        message: output.isEmpty ? "Command finished successfully" : output)
        } else {
            barCatStore.updateUIBasedOn(commandState: .finishedWithError,
                                        color: .red,
                                        message: output.isEmpty ? "Command failed" : output)
        }
    }
}

struct HostRowView_Previews: PreviewProvider {
    static var previews: some View {
        MainHostInputView()
    }
}
