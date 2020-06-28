//
//  AccountVPNUKConnectView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol AccountVPNUKConnectViewProtocol: class {
    
}

class AccountVPNUKConnectView: UIView {
    private let viewModel: AccountVPNUKConnectViewModelProtocol
    
    init(viewModel: AccountVPNUKConnectViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountVPNUKConnectView: AccountVPNUKConnectViewProtocol {
    
}
