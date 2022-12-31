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
                .sfMonoFont(.textFieldInput)
                .border(mainVM.command.state.highlightColor)
                .disabled(mainVM.command.state == .loading)
                .onChange(of: mainVM.activeHost) { host in
                    // mainVM.command.state = .notStarted
                    mainVM.activeHost.validationStatus = barCatStore.validateInput(for: host)
                }
        }
    }
    
    var portPicker: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Port")
                .captionSecondary()
            
            Picker("Port", selection: $mainVM.activeHost.port) {
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
            .onChange(of: $mainVM.activeHost.wrappedValue.port) { selectedPort in
                NSLog("Port selected: \(selectedPort)")
                mainVM.command.state = .notStarted
            }
            .labelsHidden()
            .frame(width: 80, alignment: .trailing)
            .disabled(mainVM.command.state == .loading)
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
            .disabled(mainVM.command.state == .loading || !mainVM.activeHost.isValidHostname)
            .keyboardShortcut(.defaultAction)
        }
    }
    
    // MARK: View helper methods
    
    private func runNetcat() async {
        
        withAnimation(.default) {
            mainVM.command.state = .loading
        }
        
        do {
            mainVM.command = try await processUtility.runNetcat(hostname: mainVM.activeHost.name,
                                                                portNumber: mainVM.activeHost.port.number)
        } catch {
            NSLog("Error: Command failed")
        }
        
        // TODO: Move to vm
        withAnimation(.default) {
            if mainVM.command.exitCode == 0 {
                mainVM.command.state = .finishedSuccessfully
            } else {
                mainVM.command.state = .finishedWithError
            }
        }
    }
}

struct HostRowView_Previews: PreviewProvider {
    static var previews: some View {
        MainHostInputView(mainVM: MainViewModel())
    }
}
