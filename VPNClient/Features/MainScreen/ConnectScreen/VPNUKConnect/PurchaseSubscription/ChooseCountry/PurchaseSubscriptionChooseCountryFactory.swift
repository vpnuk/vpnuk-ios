//
//  PurchaseSubscriptionChooseCountryFactory.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 16.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

class PurchaseSubscriptionChooseCountryFactory {
    func create(
        availableCountries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    ) -> ChooseCountryViewController {
        let router = PurchaseSubscriptionChooseCountryRouter()
        let viewModel = PurchaseSubscriptionChooseCountryViewModel(
            availableCountries: availableCountries,
            initialSelectedCountryIndex: initialSelectedCountryIndex,
            selectCountryAtIndexAction: selectCountryAtIndexAction,
            router: router
        )
        let viewController = ChooseCountryViewController(viewModel: viewModel)
        viewModel.view = viewController
        router.viewController = viewController
        return viewController
    }
}
