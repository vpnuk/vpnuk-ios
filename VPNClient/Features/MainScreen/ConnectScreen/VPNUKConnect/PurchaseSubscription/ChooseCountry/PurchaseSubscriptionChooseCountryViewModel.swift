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
    
    init(
        availableCountries: [Country],
        initialSelectedCountryIndex: Int?,
        selectCountryAtIndexAction: @escaping (_ index: Int) -> Void
    ) {
        self.availableCountries = availableCountries
        self.initialSelectedCountryIndex = initialSelectedCountryIndex
        self.selectCountryAtIndexAction = selectCountryAtIndexAction
        self.selectedCountryIndex = initialSelectedCountryIndex
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
                    self?.selectCountryAtIndexAction(index)
                },
                chooseButtonTitle: NSLocalizedString("Choose", comment: "")
            )
        )
    }
}
