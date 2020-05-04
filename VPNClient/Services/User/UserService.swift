//
//  UserService.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.04.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import TunnelKit

protocol UserService {
    var isSignedIn: Bool { get }
    var userData: UserData? { get set }
}

class UserServiceImpl: UserService {
    static let shared: UserService = UserServiceImpl()
    
    var isSignedIn: Bool = false
    var userData: UserData?
}
