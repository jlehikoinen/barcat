//
//  PortPicker.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 13.1.2023.
//

import SwiftUI

struct PortPicker: View {
    
    @Binding var selectedPort: Port
    var ports: [Port]
    
    var body: some View {
        
        Picker("Port", selection: $selectedPort) {
            portSection(Port.reservedPortNumberRange, header: "Privileged ports")
            portSection(Port.userPortNumberRange, header: "User ports")
        }
    }
    
    private func portSection(_ range: ClosedRange<Int>, header: String) -> some View {
    
        Section {
            ForEach(ports.filter { range ~= $0.number }, id: \.self) { port in
                HStack {
                    Spacer()
                    Text(String(port.number))
                        .font(.system(size: 13, design: .monospaced))
                        .tag(Port.ID?.some(port.id))
                }
            }
        } header: {
            Text(header)
        }
    }
}

struct PortPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PortPicker(selectedPort: .constant(.defaultPort), ports: [.defaultPort])
    }
}
