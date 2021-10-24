//
//  OpenVPNConfigurationsProvider.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol UserVPNConnectionSettingsProviderProtocol: AnyObject {
    func getUserVPNConnectionSettings() -> UserVPNConnectionSettings?
    func setUserVPNConnectionSettings(_ settings: UserVPNConnectionSettings?)
}

protocol OpenVPNConfigurationProviderProtocol: AnyObject {
    func buildOpenVPNConfiguration(
        using userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration?
    func updateWithNewOVPNConfigurationFile(fileURL url: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

class OpenVPNConfigurationsProvider {
    private var userVPNConnectionSettings: UserVPNConnectionSettings?
    private var openVPNConfigurationFromFile: OpenVPN.Configuration?
    
}

extension OpenVPNConfigurationsProvider: UserVPNConnectionSettingsProviderProtocol {
    func getUserVPNConnectionSettings() -> UserVPNConnectionSettings? {
        userVPNConnectionSettings
    }
    
    func setUserVPNConnectionSettings(_ settings: UserVPNConnectionSettings?) {
        userVPNConnectionSettings = settings
    }
}

extension OpenVPNConfigurationsProvider: OpenVPNConfigurationProviderProtocol {
    func buildOpenVPNConfiguration(
        using userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration? {
        return buildVPNConfiguration(useOldConfig: true, withUserSettings: userSettings)
    }
    
    func updateWithNewOVPNConfigurationFile(fileURL url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let vpnConfig = try self.parseVPNConfig(from: url)
                DispatchQueue.main.async {
                    self.openVPNConfigurationFromFile = vpnConfig
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func buildVPNConfiguration(
        useOldConfig: Bool,
        withUserSettings userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration? {
        if useOldConfig {
           return buildOpenVPNConfiguration(using: userSettings)
        } else {
            guard let openVPNConfigurationFromFile = openVPNConfigurationFromFile else { return nil }
            return getUpdatedVPNConfig(openVPNConfigurationFromFile, withUserSettings: userSettings)
        }
    }
    
    private func buildOldVPNConfiguration(using config: UserVPNConnectionSettings) -> OpenVPN.Configuration {
        var sessionBuilder = OpenVPN.ConfigurationBuilder()
        
        sessionBuilder.ca = OpenVPNConstants.ca
        sessionBuilder.clientCertificate = OpenVPNConstants.cert
        sessionBuilder.clientKey = OpenVPNConstants.key
        
        sessionBuilder.dnsServers = ["8.8.8.8", "8.8.4.4", "208.67.222.222", "208.67.220.220"]
        let k = OpenVPN.StaticKey(lines: OpenVPNConstants.openVPNStaticKey, direction: .client)
        sessionBuilder.tlsWrap = OpenVPN.TLSWrap(strategy: .auth, key: k!)
        sessionBuilder.cipher = .aes256gcm
        sessionBuilder.digest = .sha1
        sessionBuilder.compressionFraming = .compLZO
        sessionBuilder.renegotiatesAfter = nil
        sessionBuilder.hostname = config.hostname
        sessionBuilder.endpointProtocols = [EndpointProtocol(config.socketType.toOpenVPN(), config.port)]
        sessionBuilder.usesPIAPatches = false
        sessionBuilder.mtu = 1542
        
        return sessionBuilder.build()
    }
    
    private func getUpdatedVPNConfig(
        _ vpnConfig: OpenVPN.Configuration,
        withUserSettings userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration {
        var builder = vpnConfig.builder()
        
        builder.hostname = userSettings.hostname
        builder.endpointProtocols = [EndpointProtocol(userSettings.socketType.toOpenVPN(), userSettings.port)]
        
        return builder.build()
    }
    
    /// Parses an .ovpn file from an URL.
    private func parseVPNConfig(from url: URL) throws -> OpenVPN.Configuration {
        let file = try OpenVPN.ConfigurationParser.parsed(fromURL: url)
        return file.configuration
    }
}
