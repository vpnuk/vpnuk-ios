//
//  OpenVPNService.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import TunnelKit
import SwiftyBeaver

protocol VPNServiceDelegate: class {
    func statusUpdated(newStatus status: NEVPNStatus)
}

protocol VPNService {
    var delegate: VPNServiceDelegate? { get set }
    var configuration: (hostname: String, port: UInt16, socketType: SocketType, credentials: OpenVPN.Credentials)? { get }
    var status: NEVPNStatus { get }
    func connect()
    func disconnect()
    func connectionClicked()
    func getLog(callback: @escaping (_ log: String?) -> ())
    func configure(hostname: String, port: UInt16, socketType: SocketType, credentials: OpenVPN.Credentials)
}

class OpenVPNService: NSObject, URLSessionDataDelegate, VPNService {
    static let shared: VPNService = OpenVPNService()
    
    
    weak var delegate: VPNServiceDelegate?
    var configuration: (hostname: String, port: UInt16, socketType: SocketType, credentials: OpenVPN.Credentials)?
 
    
    private var currentManager: NETunnelProviderManager?
    
    var status = NEVPNStatus.invalid {
        didSet {
            delegate?.statusUpdated(newStatus: status)
        }
    }
    
    override init() {
        super.init()
        setup()
    }
    
    func configure(hostname: String, port: UInt16, socketType: SocketType, credentials: OpenVPN.Credentials) {
        configuration = (hostname: hostname, port: port, socketType: socketType, credentials: credentials)
    }
    
    
    private func makeProtocol() -> NETunnelProviderProtocol {
        guard let config = configuration else {
            fatalError("OpenVPNService not configured")
        }
        var sessionBuilder = OpenVPN.ConfigurationBuilder()
        
        sessionBuilder.ca = OpenVPNConstants.ca
        sessionBuilder.clientCertificate = OpenVPNConstants.cert
        sessionBuilder.clientKey = OpenVPNConstants.key
        
        let k = OpenVPN.StaticKey(lines: OpenVPNConstants.openVPNStaticKey, direction: .client)
        sessionBuilder.tlsWrap = OpenVPN.TLSWrap(strategy: .auth, key: k!)
        sessionBuilder.cipher = .aes256gcm
        sessionBuilder.digest = .sha1
        sessionBuilder.compressionFraming = .compLZO
        sessionBuilder.renegotiatesAfter = nil
        sessionBuilder.hostname = config.hostname
        sessionBuilder.endpointProtocols = [EndpointProtocol(config.socketType, config.port)]
        sessionBuilder.usesPIAPatches = false
        var builder = OpenVPNTunnelProvider.ConfigurationBuilder(sessionConfiguration: sessionBuilder.build())
        builder.mtu = 1000
        builder.shouldDebug = true
        builder.masksPrivateData = false
        
        let configuration = builder.build()
        return try! configuration.generatedTunnelProtocol(
            withBundleIdentifier: OpenVPNConstants.tunnelIdentifier,
            appGroup: OpenVPNConstants.appGroup,
            credentials: config.credentials
        )
    }
    
    
    private func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VPNStatusDidChange(notification:)),
                                               name: .NEVPNStatusDidChange,
                                               object: nil)
        
        reloadCurrentManager(nil)
//        testFetchRef()
    }
    
    func connectionClicked() {
        let block = {
            switch (self.status) {
            case .invalid, .disconnected:
                self.connect()
                
            case .connected, .connecting:
                self.disconnect()
                
            default:
                break
            }
        }
        
        if (status == .invalid) {
            reloadCurrentManager({ (error) in
                block()
            })
        }
        else {
            block()
        }
    }
    
    func connect() {
        configureVPN({ (manager) in
            return self.makeProtocol()
        }, completionHandler: { (error) in
            if let error = error {
                print("configure error: \(error)")
                return
            }
            let session = self.currentManager?.connection as! NETunnelProviderSession
            do {
                try session.startTunnel()
            } catch let e {
                print("error starting tunnel: \(e)")
            }
        })
    }
    
    func disconnect() {
        configureVPN({ (manager) in
            return nil
        }, completionHandler: { (error) in
            self.currentManager?.connection.stopVPNTunnel()
        })
    }
    
    func getLog(callback: @escaping (_ log: String?) -> ()) {
        guard let vpn = currentManager?.connection as? NETunnelProviderSession else {
            callback(nil)
            return
        }
        do {
            try vpn.sendProviderMessage(OpenVPNTunnelProvider.Message.requestLog.data) { (data) in
                guard let data = data, let log = String(data: data, encoding: .utf8) else {
                    callback(nil)
                    return
                }
                callback(log)
            }
        } catch {
            callback(nil)
        }
    }
    
    func configureVPN(_ configure: @escaping (NETunnelProviderManager) -> NETunnelProviderProtocol?, completionHandler: @escaping (Error?) -> Void) {
        reloadCurrentManager { (error) in
            if let error = error {
                print("error reloading preferences: \(error)")
                completionHandler(error)
                return
            }
            
            let manager = self.currentManager!
            if let protocolConfiguration = configure(manager) {
                manager.protocolConfiguration = protocolConfiguration
            }
            manager.isEnabled = true
            
            manager.saveToPreferences { (error) in
                if let error = error {
                    print("error saving preferences: \(error)")
                    completionHandler(error)
                    return
                }
                print("saved preferences")
                self.reloadCurrentManager(completionHandler)
            }
            
            
            let connectRule = NEOnDemandRuleConnect()
            connectRule.interfaceTypeMatch = .any
            manager.onDemandRules = [connectRule]
            manager.isOnDemandEnabled = true
        }
    }
    
    func reloadCurrentManager(_ completionHandler: ((Error?) -> Void)?) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if let error = error {
                completionHandler?(error)
                return
            }
            
            var manager: NETunnelProviderManager?
            
            for m in managers! {
                if let p = m.protocolConfiguration as? NETunnelProviderProtocol {
                    if (p.providerBundleIdentifier == OpenVPNConstants.tunnelIdentifier) {
                        manager = m
                        break
                    }
                }
            }
            
            if (manager == nil) {
                manager = NETunnelProviderManager()
            }
            
            self.currentManager = manager
            self.status = manager!.connection.status
//            self.updateButton()
            completionHandler?(nil)
        }
    }
    
    @objc private func VPNStatusDidChange(notification: NSNotification) {
        guard let status = currentManager?.connection.status else {
            print("VPNStatusDidChange")
            return
        }
        print("VPNStatusDidChange: \(status.rawValue)")
        self.status = status
//        updateButton()
    }
    
    
}
