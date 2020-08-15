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
    var plans: [Plan] = []
    
    var selectedPeriodIndex: Int?
    var periods: [Period] = []
    
    var selectedMaxUserIndex: Int?
    var maxUsers: [MaxUser] = []
  
    
    init(reloadSubscriptionsAction: @escaping Action, deps: Dependencies) {
        self.reloadSubscriptionsAction = reloadSubscriptionsAction
        self.deps = deps
    }
}

extension PurchaseSubscriptionOfferViewModel: PurchaseSubscriptionOfferViewModelProtocol {
    func viewLoaded() {
        loadSubscriptionData()
        updateView()
    }
    
    private func loadSubscriptionData() {
        let availableProducts = PurchaseProduct.availableProducts
        
        let productsGroupedByType = Dictionary(grouping: availableProducts, by: { $0.data.type })//.map { (type: $0, products: $1) }
        let types = Array(productsGroupedByType.keys)
        
       
        
        let plans: [PurchaseSubscriptionChoosePlansView.Plan] = types.map { .init(title: $0.localizedTitle, subtitle: $0.localizeDescription) }
        
        if let selectedPlanIndex = selectedPlanIndex {
            let availableProductsForSelectedPlan = productsGroupedByType[types[selectedPlanIndex]] ?? []
            let availablePeriodsForSelectedPlan = availableProductsForSelectedPlan.map { $0.data.periodMonths }
            let periods: [PurchaseSubscriptionPeriodView.Option] = availablePeriodsForSelectedPlan.map { .init(title: "\($0) months") }
            
            let availableMaxUsersForSelectedPlan = availableProductsForSelectedPlan.map { $0.data.maxUsers }
            maxUsers = availableMaxUsersForSelectedPlan.map { MaxUser(title: "\($0) users") }
        } else {
            maxUsers = []
            selectedMaxUserIndex = nil
            self.plans = []
            selectedPlanIndex = nil
            periods = []
            selectedPeriodIndex = nil
        }
    }
    
    private func buildViewData(
        from products: [PurchaseProduct]
    ) -> [PlanDetails] {
        let productsGroupedByType = Dictionary(grouping: products, by: { $0.data.type })//.map { (type: $0, products: $1) }
        
        return productsGroupedByType.map { type, products in
            PlanDetails(
                planSubscriptionType: type,
                periods: products.map { $0.data.periodMonths },
                maxUsers: products.map { $0.data.maxUsers }
            )
        }
    }
     
    private func updateView() {
        let planModels: [PurchaseSubscriptionChoosePlansView.Plan] = plans.map { .init(title: $0.title, subtitle: $0.subtitle) }
        let periodModels: [PurchaseSubscriptionPeriodView.Option] = periods.map { .init(title: $0.title) }
        let maxUsersModels: [PurchaseSubscriptionMaxUsersView.Option] = maxUsers.map { .init(title: $0.title) }
        
        
        view?.update(model: .init(
            logo: #imageLiteral(resourceName: "logo"),
            closeScreenAction: { [weak self] in
                self?.deps.router.close(completion: nil)
            },
            plansModel: .init(
                title: NSLocalizedString("Choose a Plan", comment: ""),
                plans: planModels,
                selectedPlanIndex: selectedPlanIndex,
                planSelectedAction: { [weak self] index in
                    self?.selectPlan(atIndex: index)
                },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: NSLocalizedString("""
                        There are three types of account at VPNUK. The entry level account is our ‘Shared IP‘ account, which provides users with a randomly assigned ‘dynamic’ IP address and unlimited access to all of our servers located in 22 prime locations. Our most popular account is the ‘Dedicated IP‘ account, providing users with a personal IP, its a totally unique, ‘Static’ IP address. Users also have unlimited access to all of the Shared IP servers with this account. Our 1:1 Dedicated IP account is the same as the regular Dedicated IP account, this account type is an ideal solution for users that require incoming connections.
                        """, comment: "")
                    )
                }
            ),
            
            periodModel: .init(
                title: NSLocalizedString("Choose period", comment: ""),
                options: periodModels,
                selectedOptionIndex: selectedPeriodIndex,
                optionSelectedAction: { [weak self] index in
                    self?.selectPeriod(atIndex: index)
                },
                infoTapAction: {
            
            
                }
            ),
            
            maxUsersModel: .init(
                title: NSLocalizedString("Max users", comment: ""),
                options: maxUsersModels,
                selectedOptionIndex: selectedMaxUserIndex,
                optionSelectedAction: { [weak self] index in
                    self?.selectMaxUser(atIndex: index)
                },
                infoTapAction: {
                    
                }
            ),
            
            priceModel: .init(title: NSLocalizedString("Total Price:", comment: ""),
                              moneySum: NSLocalizedString("10$", comment: "")),
            
            advantagesModel: .init(
                title: NSLocalizedString("Why Subscribe?", comment: ""),
                reasons: [.init(title: NSLocalizedString("Apps for every device", comment: "")),
                          .init(title: NSLocalizedString("160 locations worldwide", comment: "")),
                          .init(title: NSLocalizedString("24/7 customer support", comment: "")),
                          .init(title: NSLocalizedString("Unlimited bandwidth", comment: ""))]),
            
            termsDetailsModel: .init(
                title: NSLocalizedString("Subscribtion details:", comment: ""),
                termsDetails: NSMutableAttributedString(string:"-Your Apple ID account will be charged on the last day of your free trial. \n \n-Your subscription will automatically renew at the end of each billing period unless it is canceled at least 24 hours before the expiry date. \n \n-You can manage and cancel your subscriptions by going to your App Store account settings after purchase. \n \n-Any unused portion of a free trial period, if offered, will be forfeited when you purchase a subscription. \n \n-By subscribing, you agree to the Terms of Service and Privacy Policy."),
                
                termsDetailsURL: "https://www.vpnuk.net/terms/"),
            
            purchaseButtonTitle: NSLocalizedString("Start your 7-day free trial", comment: "")))
        
    }
    
      private func selectPlan(atIndex index: Int) {
          selectedPlanIndex = index
          updateView()
      }
      
      private func selectPeriod(atIndex index: Int) {
          selectedPeriodIndex = index
          updateView()
      }
      
      private func selectMaxUser(atIndex index: Int) {
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
