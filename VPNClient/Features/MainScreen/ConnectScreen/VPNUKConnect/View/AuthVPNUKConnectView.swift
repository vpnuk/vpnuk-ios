//
//  AuthVPNUKConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol AuthVPNUKConnectViewProtocol: class {
    
}

class AuthVPNUKConnectView: UIView {
    private let viewModel: AuthVPNUKConnectViewModelProtocol
    
    init(viewModel: AuthVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthVPNUKConnectView: AuthVPNUKConnectViewProtocol {
    
}
