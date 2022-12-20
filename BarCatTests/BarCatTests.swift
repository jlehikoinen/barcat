//
//  BarCatTests.swift
//  BarCatTests
//
//  Created by Janne Lehikoinen on 22.9.2022.
//

import XCTest
@testable import BarCat

final class BarCatTests: XCTestCase {

    let defaults = UserDefaults(suiteName: #file)!
    let barCatStore = BarCatStore()
    
    // MARK: Host tests
    
    func testEmptyFavoriteHosts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        XCTAssertTrue(barCatStore.favoriteHosts.isEmpty)
    }
    
    func testAddingNewHostUpdatesFavoriteHosts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        let newHost = Host.sample
        barCatStore.add(newHost)
        
        XCTAssertEqual(barCatStore.favoriteHosts.count, 1)
        XCTAssertEqual(barCatStore.favoriteHosts.first, newHost)
    }
    
    func testDeletingHostUpdatesFavoriteHosts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        let newHost = Host.sample
        let anotherHost = Host(id: UUID().uuidString, name: "test.com", port: Port(id: UUID().uuidString, number: 555, description: ""))
        
        barCatStore.add(newHost)
        barCatStore.add(anotherHost)
        barCatStore.delete([newHost.id])
        
        XCTAssertEqual(barCatStore.favoriteHosts.count, 1)
        XCTAssertEqual(barCatStore.favoriteHosts.first, anotherHost)
    }
    
    func testEditingHostUpdatesFavoriteHosts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        let originalHost = Host.sample
        var newHost = originalHost
        barCatStore.add(originalHost)
        newHost.name = "changed.com"
        newHost.port.number = 123
        barCatStore.update(originalHost, to: newHost)
        
        // Some other way to update @Published favoriteHosts?
        if let index = barCatStore.favoriteHosts.firstIndex(where: { $0.id == originalHost.id } ) {
            barCatStore.favoriteHosts[index] = newHost
        }
        
        // print(barCatStore.favoriteHosts)
        
        XCTAssertEqual(barCatStore.favoriteHosts.first!.name, "changed.com")
        XCTAssertEqual(barCatStore.favoriteHosts.first!.port.number, 123)
    }
    
    func testDuplicateHostFoundInFavoriteHosts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        barCatStore.add(Host.sample)
        let identicalHost = Host.sample
        barCatStore.add(identicalHost)
        
        XCTAssertTrue(barCatStore.hostsModel.favoriteHostsContainsDuplicates)
        XCTAssertTrue(barCatStore.hostsModel.favoriteHostsContains(identicalHost))
    }
    
    // MARK: Port tests
    
    func testEmptyDefaultPorts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        XCTAssertTrue(barCatStore.ports.isEmpty)
    }
    
    func testAddingNewPortUpdatesDefaultPorts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        let newPort = Port.sample
        barCatStore.add(newPort)
        
        XCTAssertEqual(barCatStore.ports.count, 1)
        XCTAssertEqual(barCatStore.ports.first, newPort)
    }
    
    func testDeletingPortReturnsListWithZeroPorts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        let portToBeRemoved = Port.sample
        barCatStore.add(portToBeRemoved)
        
        barCatStore.deletePort(portToBeRemoved.id)
        XCTAssertEqual(barCatStore.ports.count, 0)
    }
    
    func testDeletingPortReturnsListWithValidPorts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        for port in Port.factoryTcpPorts {
            barCatStore.add(port)
        }
        
        let portToBeRemoved = Port.default
        barCatStore.deletePort(portToBeRemoved.id)
        
        XCTAssertEqual(barCatStore.ports.count, 7)
    }
    
    func testDuplicatePortFoundInPorts() {
        
        defaults.removePersistentDomain(forName: #file)
        
        barCatStore.add(Port.sample)
        let identicalPort = Port.sample
        barCatStore.add(identicalPort)
        
        XCTAssertTrue(barCatStore.portsModel.portsContains(identicalPort))
    }
}
