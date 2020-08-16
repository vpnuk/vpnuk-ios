//
//  PurchaseSubscriptionOfferViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

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
    
    init(reloadSubscriptionsAction: @escaping Action, deps: Dependencies) {
        self.reloadSubscriptionsAction = reloadSubscriptionsAction
        self.deps = deps
    }
}

extension PurchaseSubscriptionOfferViewModel: PurchaseSubscriptionOfferViewModelProtocol {
    func viewLoaded() {
        updateView()
    }
    
    private func updateView() {
        let availableProducts = PurchaseProduct.availableProducts
        let model = buildModelForView(
            availableProducts: availableProducts,
            selectedPlanIndex: selectedPlanIndex,
            selectedPeriodIndex: selectedPeriodIndex,
            selectedMaxUsersPlan: selectedMaxUserIndex
        )

        view?.update(model: model)
    }
    
    private func buildViewData(
        from products: [PurchaseProduct]
    ) -> [PlanDetails] {
        let productsGroupedByType = Dictionary(grouping: products, by: { $0.data.type }).sorted { $0.key < $1.key }
        
        return productsGroupedByType.map { type, products in
            PlanDetails(
                planSubscriptionType: type,
                periods: products.map { $0.data.periodMonths },
                maxUsers: products.map { $0.data.maxUsers }
            )
        }
    }
    
    private func buildModelForView(
        availableProducts: [PurchaseProduct],
        selectedPlanIndex: Int?,
        selectedPeriodIndex: Int?,
        selectedMaxUsersPlan: Int?
    ) -> PurchaseSubscriptionOfferView.Model {
        let plansData = buildViewData(from: availableProducts)
        let planModels: [PurchaseSubscriptionChoosePlansView.Plan] = plansData.map {
            .init(title: $0.planSubscriptionType.localizedTitle, subtitle: $0.planSubscriptionType.localizeDescription)
        }
        
        let periodModels: [PurchaseSubscriptionPeriodView.Option]
        let maxUsersModels: [PurchaseSubscriptionMaxUsersView.Option]
        
        if let selectedPlanIndex = selectedPlanIndex {
            let selectedPlan = plansData[selectedPlanIndex]
            periodModels = selectedPlan.periods.map { .init(title: "\($0) months") }
            maxUsersModels = selectedPlan.maxUsers.map { .init(title: "\($0) users") }
        } else {
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
                    self?.selectPlan(atIndex: index)
                },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: NSLocalizedString(
                            """
                               There are three types of account at VPNUK. The entry level account is our ‘Shared IP‘ account, which provides users with a randomly assigned ‘dynamic’ IP address and unlimited access to all of our servers located in 22 prime locations. Our most popular account is the ‘Dedicated IP‘ account, providing users with a personal IP, its a totally unique, ‘Static’ IP address. Users also have unlimited access to all of the Shared IP servers with this account. Our 1:1 Dedicated IP account is the same as the regular Dedicated IP account, this account type is an ideal solution for users that require incoming connections.
                            """,
                            comment: ""
                        )
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
                    self?.selectPeriod(atIndex: index)
                },
                infoTapAction: {
                    
                    
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
                    self?.selectMaxUser(atIndex: index)
                },
                infoTapAction: {
                    
                }
            )
        }
        
        let purchaseButtonModel: PurchaseSubscriptionOfferView.PurchaseButtonModel?
        
        var priceModel: PurchaseSubscriptionPriceView.Model? = nil
//            .init(
//            title: NSLocalizedString("Total Price:", comment: ""),
//            moneySum: NSLocalizedString("10$", comment: "")
//        )
        
        if selectedPlanIndex != nil
            && selectedPeriodIndex != nil
            && selectedMaxUserIndex != nil
        {
            purchaseButtonModel = .init(
                title: NSLocalizedString("Start your 7-day free trial", comment: ""),
                isEnabled: true,
                action: {}
            )
        } else {
            purchaseButtonModel = .init(
                title: NSLocalizedString("Start your 7-day free trial", comment: ""),
                isEnabled: false,
                action: {}
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
            
            advantagesModel: .init(
                title: NSLocalizedString("Why Subscribe?", comment: ""),
                reasons: [
                    .init(title: NSLocalizedString("Apps for every device", comment: "")),
                    .init(title: NSLocalizedString("160 locations worldwide", comment: "")),
                    .init(title: NSLocalizedString("24/7 customer support", comment: "")),
                    .init(title: NSLocalizedString("Unlimited bandwidth", comment: ""))
                ]
            ),
            termsDetailsModel: .init(
                title: NSLocalizedString("Subscribtion details:", comment: ""),
                termsDetails: NSMutableAttributedString(string:"-Your Apple ID account will be charged on the last day of your free trial. \n \n-Your subscription will automatically renew at the end of each billing period unless it is canceled at least 24 hours before the expiry date. \n \n-You can manage and cancel your subscriptions by going to your App Store account settings after purchase. \n \n-Any unused portion of a free trial period, if offered, will be forfeited when you purchase a subscription. \n \n-By subscribing, you agree to the Terms of Service and Privacy Policy."),
                
                termsDetailsURL: "https://www.vpnuk.net/terms/"
            ),
            purchaseButtonModel: purchaseButtonModel
        )
        
    }

    private func selectPlan(atIndex index: Int) {
        guard selectedPlanIndex != index else { return }
        selectedPlanIndex = index
        selectedPeriodIndex = nil
        selectedMaxUserIndex = nil
        updateView()
    }
    
    private func selectPeriod(atIndex index: Int) {
        guard selectedPeriodIndex != index else { return }
        selectedPeriodIndex = index
        updateView()
    }
    
    private func selectMaxUser(atIndex index: Int) {
        guard selectedMaxUserIndex != index else { return }
        selectedMaxUserIndex = index
        updateView()
    }
}

extension PurchaseSubscriptionOfferViewModel {
    struct Plan {
        let title: String
        let subtitle: String
    }
    
    struct Period {
        let title: String
    }
    
    struct MaxUser {
        let title: String
    }
    
    struct Dependencies {
        let router: PurchaseSubscriptionOfferRouterProtocol
        let purchasesService: InAppPurchasesService
        let subscripionsAPI: SubscripionsAPI
    }
}
