//
//  OpenVPNConfigurationProviderProtocol.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 30.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol OpenVPNConfigurationProviderProtocol: AnyObject {
    var isConfigurationsLoaded: Bool { get }
    func reloadConfigurations(forceRedownload: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func getOpenVPNConfiguration(
        with userSettings: UserVPNConnectionSettings
    ) -> OpenVPN.Configuration?
}
