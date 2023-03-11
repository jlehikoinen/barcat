//
//  Host.swift
//  BarCat
//
//  Created by Janne Lehikoinen on 23.9.2022.
//

import Foundation
import RegexBuilder

struct Host {
    
    var id: String
    var name: String
    var port: Port
    var validationStatus: HostValidationStatus?
}

extension Host: Identifiable {}
extension Host: Hashable {}
extension Host: Codable {}
extension Host: Comparable {}

extension Host {
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.port = Port.default
    }
}

extension Host {
    
    static func < (lhs: Host, rhs: Host) -> Bool {
        lhs.nameAndPortNumber < rhs.nameAndPortNumber
    }
}

// MARK: Computed vars

extension Host {
    
    var nameAndPortNumber: String {
        "\(name) : \(port.number)"
    }
    
    var isValidHostname: Bool {
        isValidIPAddress || isValidFQDN
    }
    
    var isValidIPAddress: Bool {
        
        // let pattern = /^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$/
        let pattern = Regex {
            Anchor.startOfLine
            Repeat(count: 3) {
                Regex {
                    ChoiceOf {
                        Regex {
                            "25"
                            ("0"..."5")
                        }
                        Regex {
                            "2"
                            ("0"..."4")
                            ("0"..."9")
                        }
                        Regex {
                            "1"
                            ("0"..."9")
                            ("0"..."9")
                        }
                        Regex {
                            ("1"..."9")
                            ("0"..."9")
                        }
                        ("0"..."9")
                    }
                    "."
                }
            }
            ChoiceOf {
                Regex {
                    "25"
                    ("0"..."5")
                }
                Regex {
                    "2"
                    ("0"..."4")
                    ("0"..."9")
                }
                Regex {
                    "1"
                    ("0"..."9")
                    ("0"..."9")
                }
                Regex {
                    ("1"..."9")
                    ("0"..."9")
                }
                ("0"..."9")
            }
            Anchor.endOfLine
        }
        NSLog("\"\(name)\" is valid IP address: \(self.name.starts(with: pattern))")
        return self.name.starts(with: pattern)
    }
    
    var isValidFQDN: Bool {
        
        // let pattern = /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,}$/
        let pattern = Regex {
            Anchor.startOfLine
            OneOrMore {
                CharacterClass(
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            ZeroOrMore {
                Capture {
                    Regex {
                        Repeat(count: 1) {
                            One(.anyOf("-."))
                        }
                        OneOrMore {
                            CharacterClass(
                                ("a"..."z"),
                                ("0"..."9")
                            )
                        }
                    }
                }
            }
            "."
            Repeat(2...) {
                ("a"..."z")
            }
            Anchor.endOfLine
        }
        NSLog("\"\(name)\" is valid FQDN: \(self.name.starts(with: pattern))")
        return self.name.starts(with: pattern)
    }
    
    var wrappedValidationStatus: HostValidationStatus {
        validationStatus ?? .invalidHostname
    }
}

// MARK: Placeholders

extension Host {
    
    static let namePlaceholder = "domain.tld / 1.1.1.1"
}

// MARK: Sample data

extension Host {
    
    static var sample = Host(id: UUID().uuidString, name: "google.com", port: Port.sample)
    static var empty = Host(id: UUID().uuidString, name: "", port: Port.default)
}

// MARK: Examples

extension Host {
    
    static let exampleHosts = [
        Host(id: UUID().uuidString, name: "1.1.1.1", port: Port(id: "00000000-0000-0000-0000-000000000080", number: 80, description: "http")),
        Host(id: UUID().uuidString, name: "50-courier.push.apple.com", port: Port(id: "00000000-0000-0000-0000-000000005223", number: 5223, description: "APNs client")),
        Host(id: UUID().uuidString, name: "google.com", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https")),
        Host(id: UUID().uuidString, name: "wikipedia.org", port: Port(id: Port.factoryHttpsPortUuid, number: 443, description: "https"))
    ]
}
