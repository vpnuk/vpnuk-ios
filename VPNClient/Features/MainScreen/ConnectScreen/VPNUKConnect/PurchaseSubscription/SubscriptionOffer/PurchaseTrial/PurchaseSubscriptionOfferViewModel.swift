//
//  PurchaseSubscriptionOfferViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

struct PlanDetails {
    let planSubscriptionType: SubscriptionType
    let periods: [Int]
    let maxUsers: [Int]
}

protocol PurchaseSubscriptionOfferViewModelProtocol {
    func viewLoaded()
}

class PurchaseSubscriptionOfferViewModel {
    weak var view: PurchaseSubscriptionOfferViewProtocol?
    private let deps: Dependencies
    private let reloadSubscriptionsAction: Action
    
    var selectedPlanIndex: Int?
    var selectedPeriodIndex: Int?
    var selectedMaxUserIndex: Int?
    
    private var selectedDedicatedCountryIndex: Int?
    private var purchasableProductsData: PurchasableProductsData?
    /// Index of last selected country while purchasing
    private var lastPurchaseSelectedDedicatedCountryIndex: Int?
    
    private let allProducts: [PurchaseProduct]
    
    private let countries: [Country] = [
        .init(title: NSLocalizedString("United Kingdom", comment: ""), descr: "", image: UIImage(named: "uk1")!, name: "United Kingdom" ),
        .init(title: NSLocalizedString("United States", comment: ""), descr: "", image: UIImage(named: "us1")!, name: "United States" ),
        .init(title: NSLocalizedString("Italy", comment: ""), descr: "", image: UIImage(named: "it1")!, name: "Italy" ),
    ]
    
    // TODO: Currently disabled, because user can purchase IAP after trial period only, use RenewPendingSubscriptionFactory for that
    private let disableInAppPurchases: Bool = false
    
    init(allPurchasableProducts: [PurchaseProduct], reloadSubscriptionsAction: @escaping Action, deps: Dependencies) {
        self.allProducts = allPurchasableProducts
        self.reloadSubscriptionsAction = reloadSubscriptionsAction
        self.deps = deps
        deps.purchasesService.transactionUpdatedListener = { [weak self] transactions in
            self?.handlePurchaseTransactionsResults(results: transactions)
        }
    }
    
    private func handlePurchaseTransactionsResults(results: [TransactionResult]) {
        // TODO: Analyze what subscriptions were purchased
        if results.contains(where: { $0.transactionState == .purchased }) {
            sendPurchaseReceiptToServer()
        }
    }
    
    private func sendPurchaseReceiptToServer() {
        let lastSelectedCountry: Country?
        if let selectedDedicatedCountryIndex = lastPurchaseSelectedDedicatedCountryIndex, countries.count > selectedDedicatedCountryIndex {
            lastSelectedCountry = countries[selectedDedicatedCountryIndex]
        } else {
            lastSelectedCountry = nil
        }
        if let base64ReceiptData = deps.purchasesService.getBase64ReceiptData() {
            
            view?.setLoading(true)
            deps.subscripionsAPI.sendPurchaseReceipt(base64EncodedReceipt: base64ReceiptData, country: lastSelectedCountry?.name) { [weak self] result in
                guard let self = self else { return }
                self.view?.setLoading(false)
                self.reloadSubscriptionsAction()
                switch result {
                case .success(_):
                    let message = NSLocalizedString("Subscription purchased.", comment: "")
                    self.deps.router.presentAlert(message: message, completion: {
                        self.deps.router.close(completion: nil)
                    })
                case .failure(let error):
                    let message = NSLocalizedString("Purchase failed with error:", comment: "") + "\n" + error.localizedDescription
                    self.deps.router.presentAlert(message: message)
                }
                self.reloadProducts()
            }
        } else {
            let message = NSLocalizedString("Purchase failed", comment: "")
            deps.router.presentAlert(message: message)
        }
    }
    
    private func getAndCachePurchasableProductsData(
        completion: @escaping (_ result: Result<PurchasableProductsData, Error>) -> Void
    ) {
        let allProducts: [PurchaseProduct] = self.allProducts
        deps.subscripionsAPI.getSubscriptions { [weak self] result in
            switch result {
            case .success(let subscriptions):
                self?.deps.subscripionsAPI.getPurchasableProductIds { result in
                    switch result {
                    case .success(let idTrialPairs):
                        let purchasableIds = Set(idTrialPairs.keys.map { String($0) })
                        let purchasableProducts = allProducts.filter { purchasableIds.contains($0.rawValue) }
                        let purchasableProductsWithTrial: [TrialableProduct] = purchasableProducts.compactMap { product in
                            guard let id = Int(product.rawValue), let isTrial = idTrialPairs[id] else { return nil }
                            return TrialableProduct(isTrialAvailable: isTrial, product: product)
                        }
                        let data: PurchasableProductsData = .init(products: purchasableProductsWithTrial)
                        self?.purchasableProductsData = data
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension PurchaseSubscriptionOfferViewModel: PurchaseSubscriptionOfferViewModelProtocol {
    func viewLoaded() {
        updateView()
        reloadProducts()
    }
    
    private func reloadProducts() {
        view?.setLoading(true)
        deps.purchasesService.requestProducts()
        getAndCachePurchasableProductsData { result in
            self.view?.setLoading(false)
            switch result {
            case .success(_):
                self.updateView()
            case .failure(_):
                self.updateView()
                self.deps.router.presentAlert(message: NSLocalizedString("Network error", comment: ""))
            }
        }
    }
    
    private func updateView() {
        let model = buildModelForView(
            purchasableProductsData: purchasableProductsData,
            selectedPlanIndex: selectedPlanIndex,
            selectedPeriodIndex: selectedPeriodIndex,
            selectedMaxUsersPlan: selectedMaxUserIndex
        )

        view?.update(model: model)
    }
    
    private func buildViewData(
        from products: [TrialableProduct]
    ) -> [PlanDetails] {
        let productsGroupedByType = Dictionary(grouping: products, by: { $0.product.data.type }).sorted { $0.key < $1.key }
        
        return productsGroupedByType.map { type, products in
            PlanDetails(
                planSubscriptionType: type,
                periods: products.map { $0.product.data.periodMonths }.unique,
                maxUsers: products.map { $0.product.data.maxUsers }.unique
            )
        }
    }
    
    private func buildModelForView(
        purchasableProductsData: PurchasableProductsData?,
        selectedPlanIndex: Int?,
        selectedPeriodIndex: Int?,
        selectedMaxUsersPlan: Int?
    ) -> PurchaseSubscriptionOfferView.Model {
        let availableProducts = purchasableProductsData?.products ?? []
        let plansData = buildViewData(from: availableProducts)
        let planModels: [PurchaseSubscriptionChoosePlansView.Plan] = plansData.map {
            .init(title: $0.planSubscriptionType.localizedTitle, subtitle: $0.planSubscriptionType.localizeDescription)
        }
        let periodModels: [PurchaseSubscriptionPeriodView.Option]
        let maxUsersModels: [PurchaseSubscriptionMaxUsersView.Option]
        let periods: [Int]
        let maxUsers: [Int]
        
        if let selectedPlanIndex = selectedPlanIndex {
            let selectedPlan = plansData[selectedPlanIndex]
            periods = selectedPlan.periods
            maxUsers = selectedPlan.maxUsers
            periodModels = selectedPlan.periods.map { .init(title: "\($0) months") }
            maxUsersModels = selectedPlan.maxUsers.map { .init(title: "\($0) users") }
        } else {
            periods = []
            maxUsers = []
            periodModels = []
            maxUsersModels = []
        }
        
        let plansModel: PurchaseSubscriptionChoosePlansView.Model?
        if planModels.isEmpty {
            plansModel = nil
        } else {
            plansModel = .init(
                title: NSLocalizedString("Choose a Plan", comment: ""),
                plans: planModels,
                selectedPlanIndex: selectedPlanIndex,
                planSelectedAction: { [weak self] index in
                    self?.selectPlan(atIndex: index, plan: plansData[index])
                },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsPlansInfo
                    )
                }
            )
        }
        
        let periodsModel: PurchaseSubscriptionPeriodView.Model?
        if periodModels.isEmpty {
            periodsModel = nil
        } else {
            periodsModel = .init(
                title: NSLocalizedString("Choose period", comment: ""),
                options: periodModels,
                selectedOptionIndex: selectedPeriodIndex,
                optionSelectedAction: { [weak self] index in
                    self?.selectPeriod(atIndex: index, period: periods[index])
                },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsPeriodsInfo
                    )
                }
            )
        }
        
        let maxUsersModel: PurchaseSubscriptionMaxUsersView.Model?
        if maxUsersModels.isEmpty {
            maxUsersModel = nil
        } else {
            maxUsersModel = .init(
                title: NSLocalizedString("Max users", comment: ""),
                options: maxUsersModels,
                selectedOptionIndex: selectedMaxUserIndex,
                optionSelectedAction: { [weak self] index in
                    self?.selectMaxUser(atIndex: index, maxUsers: maxUsers[index])
                },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsMaxUsersInfo
                    )
                }
            )
        }
        
        let priceModel: PurchaseSubscriptionPriceView.Model?
        let isPurchaseButtonEnabled: Bool
        let isTrialAvailableForSelectedProduct: Bool
        if let selectedPurchasableProduct = getSelectedProductToPurchase(plansData: plansData) {
            isTrialAvailableForSelectedProduct = selectedPurchasableProduct.isTrialAvailable
            isPurchaseButtonEnabled = true
            
            if let product = deps.purchasesService.products.first(where: { $0.productIdentifier == selectedPurchasableProduct.product.productId }) {
                if isTrialAvailableForSelectedProduct {
                    priceModel = .init(title: NSLocalizedString("Price after trial:", comment: ""), moneySum: product.localizedPrice)
                } else {
                    priceModel = .init(title: NSLocalizedString("Price:", comment: ""), moneySum: product.localizedPrice)
                    
                }
            } else {
                priceModel = nil
            }
        } else {
            isTrialAvailableForSelectedProduct = false
            isPurchaseButtonEnabled = false
            priceModel = nil
        }
        
        let purchaseButtonModel: PurchaseSubscriptionOfferView.PurchaseButtonModel?
        
        if isTrialAvailableForSelectedProduct {
            purchaseButtonModel = .init(
                title: NSLocalizedString("Start your 7-day free trial", comment: ""),
                isEnabled: isPurchaseButtonEnabled,
                action: { [weak self] in
                    self?.purchaseTouched()
                }
            )
        } else {
            purchaseButtonModel = .init(
                title: NSLocalizedString("Purchase subscription", comment: ""),
                isEnabled: isPurchaseButtonEnabled,
                action: { [weak self] in
                    self?.purchaseTouched()
                }
            )
        }
        
        return .init(
            logo: #imageLiteral(resourceName: "logo"),
            closeScreenAction: { [weak self] in
                self?.deps.router.close(completion: nil)
            },
            plansModel: plansModel,
            periodModel: periodsModel,
            maxUsersModel: maxUsersModel,
            priceModel: priceModel,
            advantagesModel: SubscriptionConstants.subscriptionAdvantagesModel,
            termsDetailsModel: .init(
                title: NSLocalizedString("Subscribtion details:", comment: ""),
                termsDetails: SubscriptionConstants.termsDetails
            ),
            purchaseButtonModel: purchaseButtonModel
        )
        
    }

    private func selectPlan(atIndex index: Int, plan: PlanDetails) {
        if plan.planSubscriptionType == .dedicated {
            openSelectCountryForDedicatedIp()
        }
        
        guard selectedPlanIndex != index else { return }
        selectedPlanIndex = index
        selectedPeriodIndex = nil
        selectedMaxUserIndex = nil
        
        updateView()
    }
    
    private func selectPeriod(atIndex index: Int, period: Int) {
        guard selectedPeriodIndex != index else { return }
        selectedPeriodIndex = index
        updateView()
    }
    
    private func selectMaxUser(atIndex index: Int, maxUsers: Int) {
        guard selectedMaxUserIndex != index else { return }
        selectedMaxUserIndex = index
        updateView()
    }
    
    private func openSelectCountryForDedicatedIp() {
        deps.router.presentChooseCountryScreen(
            countries: countries,
            initialSelectedCountryIndex: selectedDedicatedCountryIndex,
            selectCountryAtIndexAction: { [weak self] index in
                self?.selectedDedicatedCountryIndex = index
            }
        )
    }
    
    private func purchaseTouched() {
        guard
            let selectedPlanIndex = selectedPlanIndex,
            let purchasableProductsData = purchasableProductsData
        else {
            return
        }
        let availableProducts = purchasableProductsData.products
        let plansData = buildViewData(from: availableProducts)
        let selectedPlan = plansData[selectedPlanIndex]
        guard let selectedProductToPurchase = getSelectedProductToPurchase(plansData: plansData) else {
            // Product not selected
            return
        }
        
        let selectedCountry: Country?
        if selectedPlan.planSubscriptionType == .dedicated, let selectedDedicatedCountryIndex = selectedDedicatedCountryIndex {
            selectedCountry = countries[selectedDedicatedCountryIndex]
        } else {
            selectedCountry = nil
        }
        
        makePurchase(
            productToPurchase: selectedProductToPurchase.product,
            requestTrialOnly: selectedProductToPurchase.isTrialAvailable,
            country: selectedCountry,
            quantity: 1
        )
    }
    
    private func makePurchase(productToPurchase: PurchaseProduct?, requestTrialOnly: Bool, country: Country?, quantity: Int?) {
        guard let productToPurchase = productToPurchase else {
            deps.router.presentAlert(message: NSLocalizedString("Subscription not selected. Please select subscription", comment: ""))
            return
        }
        if productToPurchase.data.type == .dedicated && (country == nil || quantity == nil) {
            deps.router.presentAlert(message: NSLocalizedString("Country not selected. Please select country", comment: ""))
            return
        }
        
        if requestTrialOnly {
            view?.setLoading(true)
            deps.subscripionsAPI.createSubscription(
                subscriptionRequest: .init(
                    productId: productToPurchase.productId,
                    productIdSource: .vpnuk,
                    quantity: quantity,
                    country: country?.name
            )) { [weak self] result in
                guard let self = self else { return }
                self.view?.setLoading(false)
                self.reloadSubscriptionsAction()
                switch result {
                case .success(_):
                    let message = NSLocalizedString("Trial subscription successfully requested:", comment: "") + "\n" + productToPurchase.localizedTitle
                    self.deps.router.presentAlert(message: message, completion: {
                        self.deps.router.close(completion: nil)
                    })
                case .failure(let error):
                    let message = NSLocalizedString("Trial subscription request failed with error:", comment: "") + "\n" + error.localizedDescription
                    self.deps.router.presentAlert(message: message)
                }
            }
        } else {
            lastPurchaseSelectedDedicatedCountryIndex = selectedDedicatedCountryIndex
            purchaseProductWithStoreKit(productToPurchase: productToPurchase)
        }
    }
    
    private func purchaseProductWithStoreKit(productToPurchase: PurchaseProduct) {
        if disableInAppPurchases {
            let message = NSLocalizedString("You can not purchase products, please request trial subscription first and prolong it later", comment: "")
            self.deps.router.presentAlert(message: message)
        } else {
            deps.purchasesService.buy(product: productToPurchase)
        }
    }
    
    private func getSelectedProductToPurchase(plansData: [PlanDetails]) -> TrialableProduct? {
        guard
            let selectedPlanIndex = selectedPlanIndex,
            let selectedPeriodIndex = selectedPeriodIndex,
            let selectedMaxUserIndex = selectedMaxUserIndex,
            let purchasableProductsData = purchasableProductsData
        else {
            return nil
        }
        let availableProducts = purchasableProductsData.products
        let selectedPlan = plansData[selectedPlanIndex]
        let selectedProductToPurchase = availableProducts.first(where: { product in
            return product.product.data.maxUsers == selectedPlan.maxUsers[selectedMaxUserIndex]
                && product.product.data.periodMonths == selectedPlan.periods[selectedPeriodIndex]
                && product.product.data.type == selectedPlan.planSubscriptionType
        })
        return selectedProductToPurchase
    }

}

extension PurchaseSubscriptionOfferViewModel {
    struct Dependencies {
        let router: PurchaseSubscriptionOfferRouterProtocol
        let purchasesService: InAppPurchasesService
        let subscripionsAPI: SubscripionsAPI
    }
    
    struct PurchasableProductsData {
        let products: [TrialableProduct]
    }
    
    struct TrialableProduct {
        let isTrialAvailable: Bool
        let product: PurchaseProduct
    }
}
