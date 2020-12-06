//
//  RenewPendingSubscriptionViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation


class RenewPendingSubscriptionViewModel {
    weak var view: PurchaseSubscriptionOfferViewProtocol?
    private var subscriptionToRenew: SubscriptionDTO
    private var orderToRenew: PendingSubscriptionOrderDTO? {
        let allProductIds = Set(allPurchasableProducts.compactMap { Int($0.productId) })
        return subscriptionToRenew.pendingOrders?.first(where: { allProductIds.contains($0.product.productId) })
    }
    private var productToRenew: PurchaseProduct? {
        return allPurchasableProducts.first(where: { Int($0.productId) == orderToRenew?.product.productId })
    }
    private let allPurchasableProducts: [PurchaseProduct]
    private let reloadSubscriptionsAction: Action
    private let deps: Deps
    
    init(
        allPurchasableProducts: [PurchaseProduct],
        subscriptionToRenew: SubscriptionDTO,
        reloadSubscriptionsAction: @escaping Action,
        deps: Deps
    ) {
        self.allPurchasableProducts = allPurchasableProducts
        self.subscriptionToRenew = subscriptionToRenew
        self.reloadSubscriptionsAction = reloadSubscriptionsAction
        self.deps = deps
        deps.purchasesService.transactionUpdatedListener = { [weak self] transactions in
            self?.handlePurchaseTransactionsResults(results: transactions)
        }
    }
}

extension RenewPendingSubscriptionViewModel: PurchaseSubscriptionOfferViewModelProtocol {
    func viewLoaded() {
        reloadSubscriptionAndProducts()
    }
    
    private func reloadSubscriptionAndProducts() {
        deps.purchasesService.requestProducts()
        
        view?.setLoading(true)
        deps.subscripionsAPI.getSubscription(
            withId: String(subscriptionToRenew.id)
        ) { [weak self] result in
            guard let self = self else { return }
            self.view?.setLoading(false)
            switch result {
            case .success(let subscriptionWithPendingOrders):
                self.subscriptionToRenew = subscriptionWithPendingOrders
            case .failure(_):
                self.deps.router.presentAlert(message: NSLocalizedString("Network error", comment: ""))
            }
            self.updateView()
        }
    }
    
    private func updateView() {
        guard let product = productToRenew else { return }
        
        let model = buildModelForView(product: product)
        view?.update(model: model)
    }
    
    
    private func buildModelForView(product: PurchaseProduct) -> PurchaseSubscriptionOfferView.Model {
        let isPurchaseButtonEnabled: Bool
        let priceModel: PurchaseSubscriptionPriceView.Model?
        
        if let skProductToPurchase = deps.purchasesService.products.first(where: { $0.productIdentifier == product.productId }) {
            isPurchaseButtonEnabled = true
            priceModel = .init(
                title: NSLocalizedString("Price:", comment: ""),
                moneySum: skProductToPurchase.localizedPrice
            )
        } else {
            isPurchaseButtonEnabled = false
            priceModel = nil
        }
        
        
        let model = PurchaseSubscriptionOfferView.Model(
            logo: #imageLiteral(resourceName: "logo"),
            closeScreenAction: { [weak self] in
                self?.deps.router.close(completion: nil)
            },
            plansModel: .init(
                title: NSLocalizedString("Renew your plan", comment: ""),
                plans: [
                    .init(title: product.localizedTitle, subtitle: product.localizeDescription)
                ],
                selectedPlanIndex: 0,
                planSelectedAction: { _ in },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsPlansInfo
                    )
                }
            ),
            periodModel: .init(
                title: NSLocalizedString("Period", comment: ""),
                options: [
                    .init(title: "\(product.data.periodMonths) months")
                ],
                selectedOptionIndex: 0,
                optionSelectedAction: { _ in },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsPeriodsInfo
                    )
                }
            ),
            maxUsersModel: .init(
                title: NSLocalizedString("Max users", comment: ""),
                options: [
                    .init(title: "\(product.data.maxUsers) users")
                ],
                selectedOptionIndex: 0,
                optionSelectedAction: { _ in },
                infoTapAction: { [weak self] in
                    self?.deps.router.presentAlert(
                        message: SubscriptionConstants.subscriptionsMaxUsersInfo
                    )
                }
            ),
            priceModel: priceModel,
            advantagesModel: SubscriptionConstants.subscriptionAdvantagesModel,
            termsDetailsModel: .init(
                title: NSLocalizedString("Subscribtion details:", comment: ""),
                termsDetails: SubscriptionConstants.termsDetails
            ),
            purchaseButtonModel: .init(
                title: NSLocalizedString("Renew subscription", comment: ""),
                isEnabled: isPurchaseButtonEnabled,
                action: { [weak self] in
                    self?.purchaseTouched()
                }
            )
        )
        
        return model
    }
    
    private func purchaseTouched() {
        renew(subscription: subscriptionToRenew)
    }
    
    private func renew(subscription: SubscriptionDTO) {
        let subscriptionCanBeRenewed = subscription.status == .onHold && subscription.pendingOrders?.isEmpty == false
        if subscriptionCanBeRenewed {
            if let productToRenew = productToRenew {
                deps.purchasesService.buy(product: productToRenew)
            }
            
        } else {
            let message = NSLocalizedString("Orders to purchase not found", comment: "")
            deps.router.presentAlert(message: message)
        }
    }
    
    private func handlePurchaseTransactionsResults(results: [TransactionResult]) {
        // TODO: Analyze what subscriptions were purchased
        if results.contains(where: { $0.transactionState == .purchased }) {
            sendPurchaseReceiptToServer()
        }
    }
    
    private func sendPurchaseReceiptToServer() {
        guard let orderToRenew = orderToRenew, let base64ReceiptData = deps.purchasesService.getBase64ReceiptData() else {
            let message = NSLocalizedString("Purchase failed", comment: "")
            deps.router.presentAlert(message: message)
            updateView()
            return
        }
        
        view?.setLoading(true)
        deps.subscripionsAPI.renewOrder(
            orderId: String(orderToRenew.orderId),
            base64EncodedReceipt: base64ReceiptData
        ) { [weak self] result in
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
            self.reloadSubscriptionAndProducts()
        }
    }
    
}

extension RenewPendingSubscriptionViewModel {
    struct Deps {
        let router: PurchaseSubscriptionOfferRouterProtocol
        let purchasesService: InAppPurchasesService
        let subscripionsAPI: SubscripionsAPI
    }
}
