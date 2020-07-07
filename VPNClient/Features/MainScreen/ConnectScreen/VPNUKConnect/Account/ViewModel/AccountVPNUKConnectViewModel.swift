//
//  VPNUKAccountConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol AccountVPNUKConnectViewModelProtocol {
    func viewDidLoad()
}

class AccountVPNUKConnectViewModel  {
    private let router: AccountVPNUKConnectRouterProtocol
    private weak var connectorDelegate: VPNConnectorDelegate?
    
    weak var view: AccountVPNUKConnectViewProtocol? {
        didSet {
            viewDidLoad()
        }
    }
    
    private var selectedSubscription: SubscriptionDTO?
    
    init(router: AccountVPNUKConnectRouterProtocol, connectorDelegate: VPNConnectorDelegate?) {
        self.router = router
        self.connectorDelegate = connectorDelegate
    }
    
}

extension AccountVPNUKConnectViewModel: AccountVPNUKConnectViewModelProtocol {
    func viewDidLoad() {
        updateSubscriptionPickerView()
    }
    
    private func updateSubscriptionPickerView() {
        if let subscription = selectedSubscription {
            let state: SubscriptionPickerView.State = .picked(
                subscriptionModel: .init(
                    subscriptionModel: .init(
                        title: subscription.productName,
                        vpnAccountsQuantity: subscription.quantity,
                        maxSessions: subscription.sessions,
                        subscriptionStatus: subscription.status,
                        periodMonths: subscription.period,
                        trialEnd: subscription.trialEndDate
                    ),
                    dedicatedServerModel: nil,
                    pickedVPNAccountModel: nil
                )
            )
            
            view?.updateSubscriptionPicker(withState: state)
        } else {
            let state: SubscriptionPickerView.State = .notPicked(
                notPickedModel: .init(
                    title: NSLocalizedString("Pick a subscription...", comment: "")
                )
            )
            
            view?.updateSubscriptionPicker(withState: state)
        }
    }
}
