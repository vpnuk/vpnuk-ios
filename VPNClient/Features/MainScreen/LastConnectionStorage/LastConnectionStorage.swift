//
//  ConnectionDataStorage.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 16.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct VPNUKConnectionState: Codable {
    let subscriptionId: String
    let subscriptionName: String
    let selectedServerIp: String?
}

struct CustomConnectionState: Codable {
    let selectedServerIp: String?
}

protocol VPNUKConnectionStateStorage {
    var vpnukConnectionState: VPNUKConnectionState? { get set }
}

protocol CustomConnectionStateStorage {
    var customConnectionState: CustomConnectionState? { get set }
}

class ConnectionStateStorageImpl: VPNUKConnectionStateStorage, CustomConnectionStateStorage {
    static let shared: VPNUKConnectionStateStorage & CustomConnectionStateStorage = ConnectionStateStorageImpl()
    
    private var defaults: UserDefaults = UserDefaults.standard
    private let customConnectionStateKey = "customConnectionState"
    private let vpnukConnectionStateKey = "vpnukConnectionState"
    
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
    
    var vpnukConnectionState: VPNUKConnectionState? {
        get {
            if let saved = defaults.object(forKey: vpnukConnectionStateKey) as? Data {
                let decoder = JSONDecoder()
                if let loaded = try? decoder.decode(VPNUKConnectionState.self, from: saved) {
                    return loaded
                }
            }
            return nil
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: vpnukConnectionStateKey)
            }
        }
    }

}
