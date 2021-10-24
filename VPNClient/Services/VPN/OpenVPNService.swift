//
//  OpenVPNService.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation
import UIKit
import NetworkExtension
import TunnelKit
import SwiftyBeaver

enum VPNError: Error {
    case error(description: String)
}

struct ConnectionData {
    let serverIP: String
    let socketType: SocketType
    let port: UInt16
}

protocol VPNServiceDelegate: AnyObject {
    func statusUpdated(newStatus status: NEVPNStatus)
    func raised(error: VPNError)
}

protocol VPNServiceProtocol {
    var currentProtocolConfiguration: NETunnelProviderProtocol? { get }
    var delegate: VPNServiceDelegate? { get set }
    var configuration: UserVPNConnectionSettings? { get }
    var status: NEVPNStatus { get }
    func connect()
    func disconnect()
    func toggleConnection()
    func getLog(callback: @escaping (_ log: String?) -> ())
    
    func configure(settings: UserVPNConnectionSettings)
    func updateWithNewOVPNConfigurationFile(fileURL url: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

class OpenVPNService: NSObject, URLSessionDataDelegate, VPNServiceProtocol {
    static let shared: VPNServiceProtocol = OpenVPNService(
        openVPNConfigurationsProvider: OpenVPNConfigurationsProvider()
    )

    weak var delegate: VPNServiceDelegate?
    
    var currentProtocolConfiguration: NETunnelProviderProtocol? {
        return currentManager?.protocolConfiguration as? NETunnelProviderProtocol
    }
    
    var status: NEVPNStatus {
        currentManager?.connection.status ?? NEVPNStatus.invalid
    }
    
    var configuration: UserVPNConnectionSettings? {
        openVPNConfigurationsProvider.getUserVPNConnectionSettings()
    }
    
    private let tunnelIdentifier = OpenVPNConstants.tunnelIdentifier
    private let appGroup = OpenVPNConstants.appGroup
    private var currentManager: NETunnelProviderManager?
    private let openVPNConfigurationsProvider: UserVPNConnectionSettingsProviderProtocol & OpenVPNConfigurationProviderProtocol
    
    init(openVPNConfigurationsProvider: UserVPNConnectionSettingsProviderProtocol & OpenVPNConfigurationProviderProtocol) {
        self.openVPNConfigurationsProvider = openVPNConfigurationsProvider
        super.init()
        setup()
    }
    
    func configure(settings: UserVPNConnectionSettings) {
        openVPNConfigurationsProvider.setUserVPNConnectionSettings(settings)
    }
    
    func updateWithNewOVPNConfigurationFile(fileURL url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        openVPNConfigurationsProvider.updateWithNewOVPNConfigurationFile(fileURL: url, completion: completion)
    }
    
    func toggleConnection() {
        let block = { [weak self] in
            guard let self = self else { return }
            
            switch self.status {
            case .invalid, .disconnected:
                self.connect()
            case .connected, .connecting:
                self.disconnect()
            default:
                break
            }
        }
        
        if status == .invalid {
            reloadCurrentManager { _ in
                block()
            }
        } else {
            block()
        }
    }
    
    func connect() {
        configureVPN(
            { manager in
                return self.makeProtocol()
            },
            completion: { result in
                switch result {
                case .success(let manager):
                    let session = manager.connection as? NETunnelProviderSession
                    do {
                        try session?.startTunnel()
                    } catch {
                        print("error starting tunnel: \(error)")
                        self.delegate?.raised(error: VPNError.error(description: "Error starting tunnel: \(error.localizedDescription)"))
                    }
                case .failure(let error):
                    print("configure error: \(error)")
                    self.delegate?.raised(error: VPNError.error(description: "Configure error: \(error.localizedDescription)"))
                }
            }
        )
    }
    
    func disconnect() {
        openVPNConfigurationsProvider.setUserVPNConnectionSettings(nil)
        
        configureVPN(
            { manager in
                return nil
            },
            completion: { [weak self] result in
                switch result {
                case .success(let manager):
                    manager.connection.stopVPNTunnel()
                case .failure(_):
                    self?.currentManager?.connection.stopVPNTunnel()
                }
            }
        )
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
    
    private func makeProtocol() -> NETunnelProviderProtocol {
        guard let config = configuration else {
            fatalError("OpenVPNService not configured")
        }
        guard let openVPNConfig = openVPNConfigurationsProvider.buildOpenVPNConfiguration(using: config) else {
            fatalError("OpenVPN configuration not loaded")
        }
        
        let sessionConfiguration = openVPNConfig
        
        var builder = OpenVPNTunnelProvider.ConfigurationBuilder(sessionConfiguration: sessionConfiguration)
        builder.shouldDebug = true
        builder.masksPrivateData = false
        
        let keychain = Keychain(group: appGroup)
        try? keychain.set(
            password: config.credentials.password,
            for: config.credentials.username,
            context: tunnelIdentifier
        )
        
        let configuration = builder.build()
        
        return try! configuration.generatedTunnelProtocol(
            withBundleIdentifier: tunnelIdentifier,
            appGroup: appGroup,
            context: tunnelIdentifier,
            username: config.credentials.username
        )
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNStatusDidChange(notification:)),
            name: .NEVPNStatusDidChange,
            object: nil
        )
        
        reloadCurrentManager(completion: { _ in })
    }
    
    private func configureVPN(
        _ configure: @escaping (NETunnelProviderManager) -> NETunnelProviderProtocol?,
        completion: @escaping (Result<NETunnelProviderManager, Error>) -> Void
    ) {
        reloadCurrentManager { result in
            switch result {
            case .success(let manager):
                let connectRule = NEOnDemandRuleConnect()
                connectRule.interfaceTypeMatch = .any
                manager.onDemandRules = [connectRule]
                
                if let protocolConfiguration = configure(manager) {
                    manager.protocolConfiguration = protocolConfiguration
                    manager.isOnDemandEnabled = self.configuration?.onDemandRuleConnect == true
                } else {
                    manager.isOnDemandEnabled = false
                }
                
                manager.isEnabled = true
                
                manager.saveToPreferences { (error) in
                    if let error = error {
                        print("error saving preferences: \(error)")
                        self.delegate?.raised(error: VPNError.error(description: "Error saving preferences: \(error.localizedDescription)"))
                        completion(.failure(error))
                        return
                    }
                    print("saved preferences")
                    self.reloadCurrentManager(completion: completion)
                }
            case .failure(let error):
                print("error reloading preferences: \(error)")
                self.delegate?.raised(error: VPNError.error(description: "Error reloading preferences: \(error.localizedDescription)"))
                completion(.failure(error))
            }
        }
    }
    
    private func getTunnelProviderManager(
        for tunnelIdentifier: String,
        completion: @escaping ((Result<NETunnelProviderManager, Error>) -> Void)
    ) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let manager = managers?.first(where: { m in
                if let p = m.protocolConfiguration as? NETunnelProviderProtocol, p.providerBundleIdentifier == tunnelIdentifier {
                    return true
                }
                return false
            })
            
            let resultManager = manager ?? NETunnelProviderManager()
            
            completion(.success(resultManager))
        }
    }
    
    private func reloadCurrentManager(completion: @escaping ((Result<NETunnelProviderManager, Error>) -> Void)) {
        getTunnelProviderManager(for: tunnelIdentifier) { result in
            switch result {
            case .success(let manager):
                self.currentManager = manager
                self.statusUpdated(manager.connection.status)
                completion(.success(manager))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @objc
    private func VPNStatusDidChange(notification: NSNotification) {
        guard let status = currentManager?.connection.status else {
            print("VPNStatusDidChange")
            return
        }
        print("VPNStatusDidChange: \(status.rawValue)")
        statusUpdated(status)
    }
    
    private func statusUpdated(_ status: NEVPNStatus) {
        delegate?.statusUpdated(newStatus: status)
    }
}

extension NETunnelProviderProtocol {
    var connectionData: ConnectionData? {
        guard let serverIP = serverIP, let socketType = socketType, let port = port else {
            return nil
        }
        return .init(serverIP: serverIP, socketType: socketType, port: port)
    }
    
    private var serverIP: String? {
        return serverAddress
    }
    
    private func getPortAndProtocol(from providerConfiguration: [String : Any]?) -> (port: UInt16, protocol: SocketType)? {
        if let tuple = (providerConfiguration?["EndpointProtocols"] as? [String])?.first {
            let arr = String(describing: tuple).split(separator: ":")
            guard let p = arr.last, let port = UInt16(p), let type = arr.first else {
                return nil
            }
            return (port: port, protocol: type == "TCP" ? .tcp : .udp)
        }
        return nil
    }
    
    private var socketType: SocketType? {
        let proto = getPortAndProtocol(from: providerConfiguration)?.protocol
        return proto
    }
    
    private var port: UInt16? {
        let port = getPortAndProtocol(from: providerConfiguration)?.port
        return port
    }
}
