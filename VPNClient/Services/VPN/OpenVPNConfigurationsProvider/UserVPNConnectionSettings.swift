//
//  UserVPNConnectionSettings.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import TunnelKit

/// Settings from user
struct UserVPNConnectionSettings {
    let hostname: String
    let port: UInt16
    let dnsServers: [String]?
    let socketType: SocketType
    let credentials: Credentials
    let onDemandRuleConnect: Bool
}

extension UserVPNConnectionSettings {
    
    /// A socket type between UDP (recommended) and TCP.
    enum SocketType: String {
        
        /// UDP socket type.
        case udp = "UDP"
        
        /// TCP socket type.
        case tcp = "TCP"
        
        /// UDP socket type (IPv4).
        case udp4 = "UDP4"
        
        /// TCP socket type (IPv4).
        case tcp4 = "TCP4"

        /// UDP socket type (IPv6).
        case udp6 = "UDP6"
        
        /// TCP socket type (IPv6).
        case tcp6 = "TCP6"
    }
    
    /// A pair of credentials for authentication.
    struct Credentials: Codable, Equatable {
        
        /// The username.
        let username: String
        
        /// The password.
        let password: String
        
        /// :nodoc
        init(_ username: String, _ password: String) {
            self.username = username
            self.password = password
        }
        
        // MARK: Equatable
        
        /// :nodoc:
        static func ==(lhs: Credentials, rhs: Credentials) -> Bool {
            return (lhs.username == rhs.username) && (lhs.password == rhs.password)
        }
    }
}

extension UserVPNConnectionSettings.SocketType {
    func toOpenVPN() -> TunnelKit.SocketType {
        switch self {
        case .tcp:
            return .tcp
        case .udp:
            return .udp
        case .udp4:
            return .udp4
        case .tcp4:
            return .tcp4
        case .udp6:
            return .udp6
        case .tcp6:
            return .tcp6
        }
    }
    
    init(socketType: TunnelKit.SocketType) {
        switch socketType {
        case .tcp:
            self = .tcp
        case .udp:
            self = .udp
        case .udp4:
            self = .udp4
        case .tcp4:
            self = .tcp4
        case .udp6:
            self = .udp6
        case .tcp6:
            self = .tcp6
        }
    }
}

extension UserVPNConnectionSettings.Credentials {
    func toOpenVPN() -> TunnelKit.OpenVPN.Credentials {
        .init(username, password)
    }
    
    init(credentials: TunnelKit.OpenVPN.Credentials) {
        username = credentials.username
        password = credentials.password
    }
}
