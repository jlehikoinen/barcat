//
//  PortsEditView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 18.11.2022.
//

import SwiftUI

struct PortsEditView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    @ObservedObject var portsEditVM = PortsEditViewModel()
    
    @State private var selectedPortId: Port.ID?
    @State private var displayingDeleteAlert = false
    @State private var deleteAlertType: DeleteAlertType = .deleteConfirmation
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    
    enum DeleteAlertType {
        case deleteConfirmation
        case portDeleteConflict
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Edit Ports")
                    .font(.title2)
                Spacer()
                deleteButton
            }
            .padding(.trailing)
            
            portsTable
            
            Divider()
                .foregroundColor(.purple)
            
            Text("Add a new port")
                .font(.title2)
                .padding(.vertical)
            
            addNewPortRow
        }
        .onAppear {
            self.displaySortedPorts()
        }
    }
    
    var deleteButton: some View {
        
        Button {
            if let portId = selectedPortId {
                displayCustomDeleteAlert(portId)
                NSLog("Selected port: \(String(describing: selectedPortId))")
            }
        } label: {
            Image(systemName: "trash")
        }
        .disabled(selectedPortId == nil)
        .help("Delete port")
        .alert(alertTitle, isPresented: $displayingDeleteAlert) {
            switch deleteAlertType {
            case .deleteConfirmation:
                Button("Delete", role: .destructive) {
                    if let portId = selectedPortId {
                        withAnimation {
                            delete(portId)
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            case .portDeleteConflict:
                Button("OK", role: .cancel) { }
            }
        } message : {
            Text(alertMsg)
        }
    }
    
    var portsTable: some View {
        
        Table(barCatStore.ports, selection: $selectedPortId) {
            
            TableColumn("Port number") { port in
                Text(String(port.number))
                    .font(.system(size: 12, design: .monospaced))
                    .padding(.vertical, 2)
            }
            .width(min: 80, ideal: 80, max: 100)
            
            
            TableColumn("Description") { port in
                Text(port.description)
                    .font(.system(size: 12, design: .monospaced))
                    .help(port.description)
            }
            .width(min: 200, ideal: 200, max: 220)
        }
    }
    
    var addNewPortRow: some View {
        
        VStack(alignment: .leading) {
            HStack {
                LabeledNumberField("Port number", placeholderText: "Add port number", number: $portsEditVM.portNumber)
                    .onChange(of: portsEditVM.portNumber ?? 0) { inputValue in
                        portInputValidation(inputValue)
                    }
                LabeledTextField("Description", placeholderText: "Add description", text: $portsEditVM.newPort.description)
                VStack(alignment: .leading, spacing: 2) {
                    Text("")
                        .captionSecondary()
                    Button("Add") {
                        withAnimation {
                            addNewPort()
                        }
                    }
                    .disabled(portsEditVM.newPort.validationStatus != .valid)
                    .keyboardShortcut(.defaultAction)
                }
            }
            PortErrorView(port: portsEditVM.debouncedNewPort)
        }
    }
    
    // MARK: View helper methods

    private func portInputValidation(_ inputValue: Int) {
        
        portsEditVM.newPort.number = inputValue
        portsEditVM.newPort.validationStatus = barCatStore.validateInput(for: portsEditVM.newPort)
    }
    
    private func addNewPort() {
        
        barCatStore.add(portsEditVM.newPort)
        
        NSLog("Resetting add new port textfields")
        portsEditVM.portNumber = nil
        portsEditVM.newPort = Port()
    }
    
    private func displayCustomDeleteAlert(_ portId: Port.ID) {
        
        if barCatStore.favoriteHostsContainsPortThatWillBeDeleted(portId) {
            self.alertTitle = "This port is in use!"
            self.alertMsg = "If you want to delete this port, first delete the hosts that use this port."
            self.deleteAlertType = .portDeleteConflict
        } else {
            self.alertTitle = "Delete this port?"
            self.alertMsg = "\(barCatStore.selectedPortNumber(for: portId))"
            self.deleteAlertType = .deleteConfirmation
        }
        displayingDeleteAlert = true
    }
    
    private func delete(_ port: Port.ID) {
        barCatStore.deletePort(port)
    }
    
    /// Use this ad-hoc sorting method when view loads
    /// List of ports is not sorted by default so when adding a new port the port appears on top of the list
    /// That's why unsorted ports are used in portsTable var
    private func displaySortedPorts() {
        barCatStore.portCollection.ports.sort()
    }
}

struct PortsEditView_Previews: PreviewProvider {
    static var previews: some View {
        PortsEditView()
            .environmentObject(BarCatStore())
    }
}
