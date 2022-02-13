//
//  OpenVPNConfigurationProviderFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 30.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation

class OpenVPNConfigurationProviderFactory {
    func create() -> OpenVPNConfigurationProviderProtocol {
        let scrambleChar = Character("C")
        return OpenVPNConfigurationsProviderCustomScramble(
            shouldUseOvpnFile: false, // Use hard-coded
            scrambleCharacter: scrambleChar,
            openVPNConfigurationRepository: OpenVPNConfigurationRepository(api: RestAPI.shared)
        )
    }
}
