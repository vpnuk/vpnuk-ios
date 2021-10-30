//
//  UserDefaults+Settings.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 21.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation
import TunnelKit

extension UserDefaults {
    
    static var isFirstLaunch: Bool {
        get {
            return UserDefaults.standard.string(forKey: "isFirstLaunch") == nil
        }
        set {
            UserDefaults.standard.set(newValue ? nil : "notFirstLaunch", forKey: "isFirstLaunch")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var socketTypeSetting: SocketType? {
        get {
            let setting = UserDefaults.standard.string(forKey: "socketTypeSetting")
            switch setting {
            case "tcp"?:
                return .tcp
            case "udp"?:
                return .udp
            default:
                return nil
            }
        }
        
        set {
            switch newValue {
            case .tcp?:
                UserDefaults.standard.set("tcp", forKey: "socketTypeSetting")
            case .udp?:
                UserDefaults.standard.set("udp", forKey: "socketTypeSetting")
            default:
                UserDefaults.standard.set(nil, forKey: "socketTypeSetting")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var portSetting: String? {
        get {
            return UserDefaults.standard.string(forKey: "portSetting")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "portSetting")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var reconnectOnNetworkChangeSetting: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "reconnectOnNetworkChange")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reconnectOnNetworkChange")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var selectedServerIP: String? {
        get {
            return UserDefaults.standard.string(forKey: "selectedServerIP")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedServerIP")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var lastServersVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastServersVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastServersVersion")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var lastOVPNVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastOVPNVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastOVPNVersion")
            UserDefaults.standard.synchronize()
        }
    }
}
