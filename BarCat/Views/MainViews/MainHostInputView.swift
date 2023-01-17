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
    @ObservedObject var mainVM: MainViewModel
    
    // Animation
    private let minScaleRate: CGFloat = 0.88
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                hostnameField
                portPicker
                runButton
            }
            HostnameErrorView(host: mainVM.debouncedActiveHost, location: .mainHostRowView)
        }
    }
    
    var hostnameField: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Hostname")
                .captionSecondary()
            
            TextField(Host.namePlaceholder, text: $mainVM.activeHost.name)
                .font(.system(size: 13, design: .monospaced))
                .border(mainVM.commandState.highlightColor)
                .disabled(mainVM.commandState == .loading)
                .onChange(of: mainVM.activeHost) { host in
                    mainVM.resetCommandOutputLabel()
                    mainVM.activeHost.validationStatus = barCatStore.validateInput(for: host)
                }
                .scaleEffect(mainVM.isHostAnimating ? minScaleRate : 1)
        }
    }
    
    var portPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Port")
                .captionSecondary()
            PortPicker(selectedPort: $mainVM.activeHost.port, ports: barCatStore.sortedPorts)
            .onChange(of: $mainVM.activeHost.wrappedValue.port) { selectedPort in
                NSLog("Port selected: \(selectedPort)")
                mainVM.resetCommandOutputLabel()
            }
            .labelsHidden()
            .frame(width: 80, alignment: .trailing)
            .disabled(mainVM.commandState == .loading)
            .scaleEffect(mainVM.isHostAnimating ? minScaleRate : 1)
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
            .disabled(mainVM.commandState == .loading || !mainVM.activeHost.isValidHostname)
            .keyboardShortcut(.defaultAction)
        }
    }
    
    // MARK: View helper methods
    
    private func runNetcat() async {
        
        var command = Command()
        
        withAnimation(.default) {
            mainVM.commandState = .loading
        }
        
        do {
            command = try await processUtility.runNetcat(hostname: mainVM.activeHost.name,
                                                                    portNumber: mainVM.activeHost.port.number)
        } catch {
            NSLog("Error: Command failed")
        }
        
        withAnimation(.default) {
            mainVM.commandState = command.exitCode == 0 ? .finishedSuccessfully : .finishedWithError
            mainVM.outputLabel = command.output
        }
    }
}

struct HostRowView_Previews: PreviewProvider {
    static var previews: some View {
        MainHostInputView(mainVM: MainViewModel())
    }
}
