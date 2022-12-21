//
//  MainHostInputView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import SwiftUI

struct MainHostInputView: View {
    
    let processUtility = ProcessUtility()
    var inputHost: Host
    
    @EnvironmentObject var barCatStore: BarCatStore

    // Create a new custom binding from inputHost
    private var activeHost: Binding<Host> {
        Binding {
            inputHost
        } set: { newValue in
            print(newValue)
            // self.activeHost.wrappedValue = newValue  // Crashes when changing the value! Causes infinite recursion.
        }
    }
    
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
                .captionSecondary()
            
            TextField(Host.namePlaceholder, text: activeHost.name)
                .sfMonoFont(.textFieldInput)
                .border(barCatStore.stateHighlightColor)
                .disabled(barCatStore.commandState == .loading)
                .onChange(of: activeHost.wrappedValue) { host in
                    barCatStore.resetHightlightAndCommandOutputLabel()
                    barCatStore.validateInput(for: host)

                    // Temp testing
                    print(inputHost)
                    // Needed?
                    activeHost.wrappedValue = inputHost
                }
        }
    }
    
    var portPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Port")
                .captionSecondary()
            
            Picker("Port", selection: activeHost.port) {
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
            .onChange(of: activeHost.wrappedValue.port) { selectedPort in
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
                .captionSecondary()
            
            Button {
                Task {
                    await runNetcat()
                }
            } label: {
                Text("Test")
            }
            .disabled(barCatStore.commandState == .loading || !activeHost.wrappedValue.isValidHostname)
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
            (exitCode, output) = try await processUtility.runNetcat(hostname: activeHost.wrappedValue.name,
                                                                    portNumber: activeHost.wrappedValue.port.number)
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
        MainHostInputView(inputHost: Host.sample)
    }
}
