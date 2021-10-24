//
//  ServerUpdatesChecker.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation

protocol ServerUpdatesCheckerProtocol: AnyObject {
    func checkVersions(callback: @escaping (_ updates: Result<ServerUpdatesChecker.Updates, Error>) -> Void)
    func setLastServersVersion(_ version: Int)
    func setLastOVPNVersion(_ version: Int)
}

class ServerUpdatesChecker: ServerUpdatesCheckerProtocol {
    private let api: VersionsAPI
    
    init(api: VersionsAPI) {
        self.api = api
    }
    
    func checkVersions(callback: @escaping (_ updates: Result<Updates, Error>) -> Void) {
        api.getVersions { result in
            let shouldUpdateServerlist: Bool
            let shouldUpdateOVPNFile: Bool
            
            switch result {
            case .success(let versions):
                let sVersion = versions.servers
                if let lastServersVersion = UserDefaults.lastServersVersion, let sVersion = sVersion, let currentServerVersion = Int(sVersion), let currentClientVersion = Int(lastServersVersion), currentClientVersion == currentServerVersion {
                    shouldUpdateServerlist = false
                } else {
                    shouldUpdateServerlist = true
                }
                
                let ovpnVersion = versions.ovpn
                if let lastOVPNVersion = UserDefaults.lastOVPNVersion, let ovpnVersion = ovpnVersion, let currentOvpnVersion = Int(ovpnVersion), let currentClientVersion = Int(lastOVPNVersion), currentClientVersion == currentOvpnVersion {
                    shouldUpdateOVPNFile = false
                } else {
                    shouldUpdateOVPNFile = true
                }
                
                callback(.success(.init(versionsOnServer: versions, shouldUpdateServerlist: shouldUpdateServerlist, shouldUpdateOVPNFile: shouldUpdateOVPNFile)))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func setLastServersVersion(_ version: Int) {
        UserDefaults.lastServersVersion = String(version)
    }
    
    func setLastOVPNVersion(_ version: Int) {
        UserDefaults.lastOVPNVersion = String(version)
    }
}

extension ServerUpdatesChecker {
    struct Updates {
        let versionsOnServer: VersionsDTO
        let shouldUpdateServerlist: Bool
        let shouldUpdateOVPNFile: Bool
    }
}
