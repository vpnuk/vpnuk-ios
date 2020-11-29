//
//  InAppPurchasesService.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 02.08.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//


import StoreKit
import Foundation
import Alamofire

typealias TransactionResult = (product: PurchaseProduct?, transactionState: SKPaymentTransactionState, error: Error?)

enum InAppPurchaseError: Error {
    case noReceiptUrl
}

protocol InAppPurchasesService: AnyObject {
    var products: [SKProduct] { get }
    var transactionUpdatedListener: ((_ result: [TransactionResult]) -> Void)? { get set }
    func requestProducts() -> Bool
    func buy(product: PurchaseProduct)
    func restorePurchases()
    func getBase64ReceiptData() -> String?
    
    func getReceiptResponse(completion: @escaping (_ response: Result<ReceiptResponseEntity, Error>) -> Void)
}

class InAppPurchasesServiceMock: InAppPurchasesService {
    func requestProducts() -> Bool {
        return true
    }
    
    func buy(product: PurchaseProduct) {
        
    }
    
    func restorePurchases() {
        
    }
    
    var products: [SKProduct] = []
    
    var transactionUpdatedListener: (([TransactionResult]) -> Void)?
    
    func updateSubscriptionsExpiration() {
        
    }
    
    func getBase64ReceiptData() -> String? {
        return nil
    }
    
    func getReceiptResponse(completion: @escaping (_ response: Result<ReceiptResponseEntity, Error>) -> Void) {
        completion(.success(.init()))
    }
}

class InAppPurchasesServiceImpl: NSObject {
    private let availableProducts: [PurchaseProduct]
    private let allProducts: [PurchaseProduct]
    var products: [SKProduct] = []
    private var productsRequest: SKProductsRequest?
    var transactionUpdatedListener: (([TransactionResult]) -> Void)?
    private let paymentQueue: SKPaymentQueue
    private let defaults: UserDefaults
    private let fileManager: FileManager
    
    init(
        availableProducts: [PurchaseProduct],
        allProducts: [PurchaseProduct],
        paymentQueue: SKPaymentQueue = SKPaymentQueue.default(),
        defaults: UserDefaults = .standard,
        fileManager: FileManager
    ) {
        self.availableProducts = availableProducts
        self.allProducts = allProducts
        self.paymentQueue = paymentQueue
        self.defaults = defaults
        self.fileManager = fileManager
        super.init()
        paymentQueue.add(self)
    }
}

extension InAppPurchasesServiceImpl: InAppPurchasesService {
    
    func buy(product: PurchaseProduct) {
        if let skProduct = (products.first { $0.productIdentifier == product.rawValue }) {
            let payment = SKPayment(product: skProduct)
            paymentQueue.add(payment)
        }
    }
    
    
    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    @discardableResult
    func requestProducts() -> Bool {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(PurchaseProduct.allCases.map { $0.rawValue } ))
            productsRequest = request
            request.delegate = self
            request.start()
            return true
        } else {
            return false
        }
    }
    
    func getBase64ReceiptData() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            fileManager.fileExists(atPath: appStoreReceiptURL.path),
            let receiptData = NSData(contentsOf: appStoreReceiptURL) {
            return  receiptData.base64EncodedString()
        } else {
            return nil
        }
    }
    
    func getReceiptResponse(completion: @escaping (_ response: Result<ReceiptResponseEntity, Error>) -> Void) {
        //        prod: https://buy.itunes.apple.com/verifyReceipt
        //        dev: https://sandbox.itunes.apple.com/verifyReceipt
        let verificationUrlString = "https://sandbox.itunes.apple.com/verifyReceipt"
        let sharedSecret = "888"
        
        if let base64ReceiptData = getBase64ReceiptData() {
            
            let receiptDictionary = ["receipt-data" : base64ReceiptData, "password" : sharedSecret]
            let requestData = try! JSONSerialization.data(withJSONObject: receiptDictionary)
            
            let storeURL = URL(string: verificationUrlString)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData

            AF.request(storeRequest).responseData(completionHandler: { result in
                if let error = result.error {
                    completion(.failure(error))
                } else {
                    let data = result.data ?? Data()
                    do {
                        
                        let decoded = try JSONDecoder().decode(ReceiptResponseEntity.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            })
            
        } else {
            completion(.failure(InAppPurchaseError.noReceiptUrl))
        }
    }

    private func getPurchasedProducts(
        fromReceiptResponse response: ReceiptResponseEntity?
    ) -> (purchased: Set<PurchaseProduct>, notPurchased: Set<PurchaseProduct>)? {
        let currentDate = Date()
        if let latestReceipts = response?.latest_receipt_info {
            
            let allProducts = Set(self.allProducts)
            let purchasedProducts = Set(
                latestReceipts.filter {
                    if let expires = $0.expiresDate {
                        return expires >= currentDate
                    } else {
                        return false
                    }
                }
                .compactMap { $0.product }
            )
            let notPurchasedProducts = allProducts.subtracting(purchasedProducts)
            
            return (purchased: purchasedProducts, notPurchased: notPurchasedProducts)
        }
        return nil
    }
    
    private func setPurchased(product: PurchaseProduct, isPurchased: Bool) {
        defaults.set(isPurchased, forKey: product.rawValue)
        defaults.synchronize()
    }
}

extension InAppPurchasesServiceImpl: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var result = [TransactionResult]()
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                let product = PurchaseProduct(rawValue: transaction.payment.productIdentifier)!
                result.append(TransactionResult(product: product, transactionState: transaction.transactionState, error: transaction.error))
                setPurchased(product: product, isPurchased: true)
                paymentQueue.finishTransaction(transaction)
            case .failed:
                result.append(TransactionResult(product: nil, transactionState: transaction.transactionState, error: transaction.error))
                paymentQueue.finishTransaction(transaction)
            case .restored:
                if let id = transaction.original?.payment.productIdentifier, let product = PurchaseProduct(rawValue: id) {
                    result.append(TransactionResult(product: product, transactionState: transaction.transactionState, error: transaction.error))
                    
                    paymentQueue.finishTransaction(transaction)
                }
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
        
        // for case when user press "restore subscriptions" => validate receipt again
        let restoredTransactions = transactions.contains(where: { $0.transactionState == .restored })
        if restoredTransactions {
            // TODO:
        }
        
        transactionUpdatedListener?(result)
    }
    
    private func handleTransactionResults(_ results: [TransactionResult]) {
        let havePurchasedProducts = results.contains(where: { $0.transactionState == .purchased || $0.transactionState == .restored })
        if havePurchasedProducts {
            
        }
    }
        
}



//
//import Foundation
//import StoreKit
//import RxSwift
//import RxCocoa
//import RxAlamofire
//import Alamofire
//
//typealias TransactionResult = (product: PurchaseProduct?, transactionState: SKPaymentTransactionState, error: Error?)
//
//enum CustomIAPError: Error {
//    case premiumWasAlreadyPurchased
//}
//
//extension CustomIAPError: LocalizedError {
//    public var errorDescription: String? {
//        switch self {
//        case .premiumWasAlreadyPurchased:
//            return NSLocalizedString("Premium was already purchased", comment: "")
//        }
//    }
//}
//
//protocol InAppPurchasesService: class {
//    func requestProducts() -> Bool
//    func buy(product: PurchaseProduct)
//    func restorePurchases()
//    func getPurchasedProducts() -> [PurchaseProduct]
//    var products: Observable<[SKProduct]> { get }
//    var isPremiumPurchased: Observable<Bool> { get }
//    var transactionUpdated: Observable<[TransactionResult]> { get }
//    var purchaseProductsPresentation: Observable<[PurchasePresentationEntity]> { get }
//    func updateSubscriptionsExpiration()
//}
//
//class InAppPurchasesServiceImpl: NSObject, InAppPurchasesService {
//    private var productsRequest = SKProductsRequest()
//    private let products: [SKProduct] = []
//    private let transactionUpdatedSubject = PublishSubject<[TransactionResult]>()
//
//    var transactionUpdated: Observable<[TransactionResult]> {
//        return transactionUpdatedSubject.asObservable()
//    }
//
//    var purchaseProductsPresentation: Observable<[PurchasePresentationEntity]> {
//        return transactionUpdated
//            .map { _ in () }
//            .startWith(())
//            .flatMapLatest { [weak self] transactions -> Observable<[PurchasePresentationEntity]> in
//                guard let `self` = self else {
//                    return .empty()
//                }
//                let purchased = self.getPurchasedProducts()
//                return self.products.map { products -> [PurchasePresentationEntity] in
//                    var result = [PurchasePresentationEntity]()
//                    for product in products {
//                        let pp = PurchaseProduct(rawValue: product.productIdentifier)!
//                        let isPurchased = purchased.contains { $0.rawValue == product.productIdentifier }
//                        let price = product.localizedPrice ?? "\(product.price)"
//                        result.append(PurchasePresentationEntity(product: pp, price: price, isPurchased: isPurchased))
//                    }
//                    return result
//                }
//        }.share()
//
//    }
//
//    override init() {
//        super.init()
//        SKPaymentQueue.default().add(self)
//    }
//
//    func restorePurchases() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    @discardableResult
//    func requestProducts() -> Bool {
//        if SKPaymentQueue.canMakePayments() {
//            let request = SKProductsRequest(productIdentifiers: Set(PurchaseProduct.allCases.map { $0.rawValue } ))
//            productsRequest = request
//            request.delegate = self
//            request.start()
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func buy(product: PurchaseProduct) {
//        if let skProduct = (products.first { $0.productIdentifier == product.rawValue }) {
//            if !hasPremium() {
//                let payment = SKPayment(product: skProduct)
//                SKPaymentQueue.default().add(payment)
//            } else {
//                transactionUpdatedSubject.onNext([(product: product, transactionState: .failed, error: CustomIAPError.premiumWasAlreadyPurchased)])
//            }
//        }
//    }
//
//
//    func setPurchased(product: PurchaseProduct, isPurchased: Bool) {
//        UserDefaults.standard.set(isPurchased, forKey: product.rawValue)
//        UserDefaults.standard.synchronize()
//    }
//
//    func getPurchasedProducts() -> [PurchaseProduct] {
//        let defaults = UserDefaults.standard
//        return PurchaseProduct.allCases.filter { defaults.bool(forKey: $0.rawValue) }
//    }
//
//}
//
//extension InAppPurchasesServiceImpl: SKProductsRequestDelegate, SKPaymentTransactionObserver {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        products = response.products
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print(error)
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        var result = [TransactionResult]()
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchased:
//                let product = PurchaseProduct(rawValue: transaction.payment.productIdentifier)!
//                result.append(TransactionResult(product: product, transactionState: transaction.transactionState, error: transaction.error))
//                setPurchased(product: product, isPurchased: true)
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .failed:
//                result.append(TransactionResult(product: nil, transactionState: transaction.transactionState, error: transaction.error))
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .restored:
//                if let id = transaction.original?.payment.productIdentifier, let product = PurchaseProduct(rawValue: id) {
//                    result.append(TransactionResult(product: product, transactionState: transaction.transactionState, error: transaction.error))
//
//                    SKPaymentQueue.default().finishTransaction(transaction)
//                }
//
//            case .deferred:
//                break
//            case .purchasing:
//                break
//            }
//        }
//
//        // for case when user press "restore subscriptions" => validate receipt again
//        let restoredTransactions = transactions.contains(where: { $0.transactionState == .restored })
//        if restoredTransactions {
//            updateSubscriptionsExpiration()
//        }
//
//        isPremiumPurchasedRelay.accept(hasPremium())
//
//        transactionUpdatedSubject.onNext(result)
//    }
//
//    private func hasPremium() -> Bool {
//        return getPurchasedProducts().contains(where: { $0.isPremium })
//    }
//
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        print("restored")
//    }
//
//
//    // MARK: check autorenewable
//
//    func updateSubscriptionsExpiration() {
//        getReceiptResponse()
//            .asObservable()
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .map(updatePurchases)
//            .observeOn(MainScheduler.instance)
//            .bind(to: isPremiumPurchasedRelay)
//            .disposed(by: disposeBag)
//    }
//
//    private func updatePurchases(fromReceiptResponse response: ReceiptResponseEntity?) -> Bool {
//        let currentDate = Date()
//        if let latestReceipts = response?.latest_receipt_info {
//
//            let allProducts = Set(PurchaseProduct.allCases)
//            let purchasedProducts = Set(
//                latestReceipts.filter {
//                    if let expires = $0.expiresDate {
//                        return expires >= currentDate
//                    } else {
//                        return false
//                    }
//                }
//                .compactMap { $0.product }
//            )
//            let notPurchasedProducts = allProducts.subtracting(purchasedProducts)
//
//            notPurchasedProducts.forEach { setPurchased(product: $0, isPurchased: false) }
//            purchasedProducts.forEach { setPurchased(product: $0, isPurchased: true) }
//        }
//        return hasPremium()
//    }
//
//    private func getReceiptResponse() -> Single<ReceiptResponseEntity?> {
//        //        prod: https://buy.itunes.apple.com/verifyReceipt
//        //        dev: https://sandbox.itunes.apple.com/verifyReceipt
//        let verificationUrlString = "https://buy.itunes.apple.com/verifyReceipt"
//        let sharedSecret = "888"
//
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//            FileManager.default.fileExists(atPath: appStoreReceiptURL.path),
//            let receiptData = NSData(contentsOf: appStoreReceiptURL) {
//
//            let receiptDictionary = ["receipt-data" : receiptData.base64EncodedString(), "password" : sharedSecret]
//            let requestData = try! JSONSerialization.data(withJSONObject: receiptDictionary)
//
//            let storeURL = URL(string: verificationUrlString)!
//            var storeRequest = URLRequest(url: storeURL)
//            storeRequest.httpMethod = "POST"
//            storeRequest.httpBody = requestData
//
//            let result = Alamofire.request(storeRequest)
//                .rx
//                .data()
//                .map { data -> ReceiptResponseEntity? in
//                    do {
//                        return try JSONDecoder().decode(ReceiptResponseEntity.self, from: data)
//                    } catch {
//                        print(error)
//                        return nil
//                    }
//                }
//                .asSingle()
//
//            return result
//
//        } else {
//            return .just(nil)
//        }
//    }
//
//}
