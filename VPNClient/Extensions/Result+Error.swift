//
//  Result+Error.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 27.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation

extension Result {
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

