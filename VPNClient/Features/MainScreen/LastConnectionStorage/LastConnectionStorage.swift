//
//  ConnectionDataStorage.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 16.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct VPNUKConnectionSelectedSubscriptionState: Codable {
    let subscriptionId: Int
    let subscriptionName: String
    let vpnAccountUsername: String?
}

struct VPNUKConnectionSelectedServerState: Codable {
    let selectedServerIp: String
    init?(selectedServerIp: String?) {
        if let selectedServerIp = selectedServerIp {
            self.selectedServerIp = selectedServerIp
        } else {
            return nil
        }
    }
}

struct CustomConnectionState: Codable {
    let selectedServerIp: String?
}

protocol VPNUKConnectionStateStorage {
    var vpnukConnectionSelectedSubscriptionState: VPNUKConnectionSelectedSubscriptionState? { get set }
    var vpnukConnectionSelectedServerState: VPNUKConnectionSelectedServerState? { get set }
}

protocol CustomConnectionStateStorage {
    var customConnectionState: CustomConnectionState? { get set }
}

class ConnectionStateStorageImpl: VPNUKConnectionStateStorage, CustomConnectionStateStorage {

    
    static let shared: VPNUKConnectionStateStorage & CustomConnectionStateStorage = ConnectionStateStorageImpl()
    
    private var defaults: UserDefaults = UserDefaults.standard
    private let customConnectionStateKey = "customConnectionState"
    
    private let vpnukConnectionSubscriptionStateKey = "vpnukConnectionSubscriptionState"
    private let vpnukConnectionServerStateKey = "vpnukConnectionServerState"
    
    var customConnectionState: CustomConnectionState? {
        get {
            if let saved = defaults.object(forKey: customConnectionStateKey) as? Data {
                let decoder = JSONDecoder()
                if let loaded = try? decoder.decode(CustomConnectionState.self, from: saved) {
                    return loaded
                }
            }
            return nil
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: customConnectionStateKey)
            }
        }
    }
    
    var vpnukConnectionSelectedSubscriptionState: VPNUKConnectionSelectedSubscriptionState? {
        get {
            if let saved = defaults.object(forKey: vpnukConnectionSubscriptionStateKey) as? Data {
                let decoder = JSONDecoder()
                if let loaded = try? decoder.decode(VPNUKConnectionSelectedSubscriptionState.self, from: saved) {
                    return loaded
                }
            }
            return nil
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: vpnukConnectionSubscriptionStateKey)
            }
        }
    }
    
    var vpnukConnectionSelectedServerState: VPNUKConnectionSelectedServerState? {
        get {
            if let saved = defaults.object(forKey: vpnukConnectionServerStateKey) as? Data {
                let decoder = JSONDecoder()
                if let loaded = try? decoder.decode(VPNUKConnectionSelectedServerState.self, from: saved) {
                    return loaded
                }
            }
            return nil
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: vpnukConnectionServerStateKey)
            }
        }
    }

}
