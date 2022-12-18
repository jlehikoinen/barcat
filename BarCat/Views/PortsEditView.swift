//
//  PortsEditView.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 18.11.2022.
//

import Combine
import SwiftUI

struct PortsEditView: View {
    
    @EnvironmentObject var barCatStore: BarCatStore
    
    @State private var newPort = Port()
    @State private var debouncedNewPort = Port()
    
    
    @State private var newPortNumber = ""
    @State private var debouncedNewPortNumber = ""
    @State private var newPortDescription = ""
    
    
    @State private var selectedPortId: Port.ID?
    @State private var displayingDeleteAlert = false
    @State private var deleteAlertType: DeleteAlertType = .deleteConfirmation
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    
    let newPortPublisher = PassthroughSubject<String, Never>()
    
    enum DeleteAlertType {
        case deleteConfirmation
        case portDeleteConflict
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Edit ports")
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
        .buttonStyle(.plain)
        .disabled(selectedPortId == nil)
        .help("Delete port")
        .alert(alertTitle, isPresented: $displayingDeleteAlert) {
            switch deleteAlertType {
            case .deleteConfirmation:
                Button("Delete", role: .destructive) {
                    if let portId = selectedPortId {
                        delete(portId)
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
                    .sfMonoFont(.tableRow)
                    .padding(.vertical, 2)
            }
            .width(min: 80, ideal: 80, max: 100)
            
            
            TableColumn("Description") { port in
                Text(port.description)
                    .sfMonoFont(.tableRow)
                    .help(port.description)
            }
            .width(min: 200, ideal: 200, max: 220)
        }
    }
    
    var addNewPortRow: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Port number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Add port number", text: $newPortNumber)
                        .sfMonoFont(.textFieldInput)
                        .onChange(of: newPortNumber) { number in
                            newPortPublisher.send(number)
                            // Workaround for port number
                            newPort = Port(id: UUID().uuidString, number: Int(number) ?? 0, description: "")
                            self.validate(newPort)
                        }
                        .onReceive(
                            newPortPublisher
                                .debounce(for: AppConfig.portInputDelayInSeconds,
                                          scheduler: DispatchQueue.main)
                        ) { debouncedPortNumber in
                            print("Debounced port number: \(debouncedPortNumber)")
                            self.debouncedNewPortNumber = debouncedPortNumber
                        }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Add description", text: $newPortDescription)
                        .sfMonoFont(.textFieldInput)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Add") {
                        addNewPort()
                    }
                    .disabled(newPort.validationStatus != .valid)
                    .keyboardShortcut(.defaultAction)
                }
            }
            PortErrorView(port: debouncedNewPort)
        }
    }
    
    // MARK: View helper methods
    
    private func addNewPort() {
        
        newPort.description = newPortDescription
        barCatStore.add(newPort)
        // TODO: Text field value is not emptied
        NSLog("Resetting add new port textfields")
        self.newPortNumber = ""
        self.newPortDescription = ""
    }
    
    private func validate(_ port: Port) {
        newPort.validationStatus = barCatStore.validateInput(for: port)
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
    
    private func displaySortedPorts() {
        barCatStore.ports = barCatStore.sortedPorts
    }
}

struct PortsEditView_Previews: PreviewProvider {
    static var previews: some View {
        PortsEditView()
    }
}
