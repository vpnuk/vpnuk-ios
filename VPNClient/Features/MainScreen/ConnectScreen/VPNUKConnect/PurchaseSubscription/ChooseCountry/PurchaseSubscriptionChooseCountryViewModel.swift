//
//  ChooseCountryViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 16.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol PurchaseSubscriptionChooseCountryViewModelProtocol: AnyObject {
    func viewLoaded()
}

class PurchaseSubscriptionChooseCountryViewModel {
    weak var view: ChooseCountryViewProtocol?
    
    private let availableCountries: [Country]
    private let initialSelectedCountryIndex: Int?
    private let selectCountryAtIndexAction: (_ index: Int) -> Void
    private var selectedCountryIndex: Int?
    private let router: PurchaseSubscriptionChooseCountryRouterProtocol
    
    init(
        availableCountries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void,
        router: PurchaseSubscriptionChooseCountryRouterProtocol
    ) {
        self.availableCountries = availableCountries
        self.initialSelectedCountryIndex = initialSelectedCountryIndex
        self.selectCountryAtIndexAction = selectCountryAtIndexAction
        self.selectedCountryIndex = initialSelectedCountryIndex
        self.router = router
    }
}

extension PurchaseSubscriptionChooseCountryViewModel: PurchaseSubscriptionChooseCountryViewModelProtocol {
    func viewLoaded() {
        updateView()
    }
    
    private func updateView() {
        let countriesModels: [PurchaseSubscriptionChooseCountryView.Country] = availableCountries.map { .init(title: $0.title, imageFlag: $0.image) }
        view?.update(
            model: .init(
                title: NSLocalizedString("Choose country of your dedicated server", comment: ""),
                countries: countriesModels,
                selectedCountryIndex: selectedCountryIndex,
                countrySelectedAction: { [weak self] (index) in
                    self?.selectedCountryIndex = index
                    self?.updateView()
                },
                chooseButtonModel: .init(
                    title: NSLocalizedString("Choose", comment: ""),
                    isEnabled: selectedCountryIndex != nil,
                    action: { [weak self] in
                        guard let self = self, let selectedCountryIndex = self.selectedCountryIndex else { return }
                        self.router.close(completion: {
                            self.selectCountryAtIndexAction(selectedCountryIndex)
                        })
                    }
                ),
                closeAction: { [weak self] in
                    self?.router.close(completion: nil)
                }
            )
        )
    }
}
