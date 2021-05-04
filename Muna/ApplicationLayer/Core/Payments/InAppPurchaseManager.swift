//
//  InAppPurchaseManager.swift
//  Muna
//
//  Created by Egor Petrov on 08.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation
import SwiftyStoreKit

final class InAppPurchaseManager {
    enum ValidationState {
        case purchased
        case notPurchased
        case expired
        case noProductToValidate
        case error(Error)
    }

    enum PurchaseState {
        case purchased
        case cancelled
        case notPurchased
        case error(Error)
    }
    
    enum ProductRequestState {
        case requested
        case error(Error)
    }

    typealias PurchaseCompletion = (PurchaseState) -> Void
    typealias ValidationCompletion = (ValidationState) -> Void

    private(set) var monthlyProductItem = InAppProductItem(id: ProductIds.monthly, productType: .subscription)
    private(set) var oneTimeTipProductItem = InAppProductItem(id: ProductIds.oneTimeTip, productType: .oneTime)

    var products: [String: InAppProductItem] {
        return [
            ProductIds.monthly.rawValue: self.monthlyProductItem,
            ProductIds.oneTimeTip.rawValue: self.oneTimeTipProductItem
        ]
    }

    private let inAppProductsService: InAppProductsService
    private let inAppPurchaseService: InAppProductPurchaseService
    private let inAppRecieptValidationService: InAppRecieptValidationService

    private var loadingProductsTry = 0

    init(
        inAppProductsService: InAppProductsService,
        inAppPurchaseService: InAppProductPurchaseService,
        inAppRecieptValidationService: InAppRecieptValidationService
    ) {
        self.inAppProductsService = inAppProductsService
        self.inAppPurchaseService = inAppPurchaseService
        self.inAppRecieptValidationService = inAppRecieptValidationService

        self.inAppPurchaseService.checkTransactions = { [weak self] purchases in
            guard !purchases.isEmpty else { return }
            self?.validateSubscription(nil)
        }
    }

    func completeTransaction() {
        self.inAppPurchaseService.completeTransactions()
    }

    func loadProducts(_ completion: ((ProductRequestState) -> Void)? = nil) {
        self.inAppProductsService.requestProducts(forIds: [.monthly, .oneTimeTip]) {
            switch $0 {
            case let .requested(products):
                self.monthlyProductItem.product = products.first(where: { $0.productIdentifier ==  ProductIds.monthly.rawValue })
                self.oneTimeTipProductItem.product = products.first(where: { $0.productIdentifier ==  ProductIds.oneTimeTip.rawValue })
                completion?(.requested)
            case let .failed(error):
                completion?(.error(error))
                appAssertionFailure("Error on loading products: \(error)")
            case .none:
                completion?(.error(MunaError.uknownError))
            case .requesting:
                break
            }
        }
    }

    func buyProduct(_ productId: ProductIds, completion: @escaping PurchaseCompletion) {
        guard let inAppItem = self.products[productId.rawValue], let product = inAppItem.product else {
            self.loadingProductsTry += 1
            if loadingProductsTry < 3 {
                self.loadProducts { [weak self] result in
                    switch result {
                    case .requested:
                        self?.buyProduct(productId, completion: completion)
                    case .error:
                        OperationQueue.main.addOperation {
                            completion(.error(MunaError.cantGetInAppProducts))
                        }
                    }
                }
            } else {
                self.loadingProductsTry = 0
                OperationQueue.main.addOperation {
                    completion(.error(MunaError.cantGetInAppProducts))
                }
            }
            return
        }
        self.loadingProductsTry = 0

        self.inAppPurchaseService.buyProduct(product) { [weak self] result in
            switch result {
            case let .success(purchaseDetails):
                switch inAppItem.productType {
                case .oneTime:
                    ServiceLocator.shared.securityStorage.save(
                        double: purchaseDetails.originalPurchaseDate.timeIntervalSince1970,
                        for: SecurityStorage.Key.purchaseTipDate.rawValue
                    )
                    completion(.purchased)
                case .subscription:
                    ServiceLocator.shared.securityStorage.save(
                        string: product.productIdentifier,
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
                    self?.validateSubscription { result in
                        switch result {
                        case .purchased, .noProductToValidate:
                            completion(.purchased)
                        case let .error(error):
                            completion(.error(error))
                        case .notPurchased:
                            completion(.notPurchased)
                        case .expired:
                            completion(.error(MunaError.uknownError))
                        }
                    }
                }
            case let .failure(error):
                switch error.code {
                case .paymentCancelled:
                    completion(.cancelled)
                default:
                    completion(.error(error))
                    appAssertionFailure("Error: \(error) on purchasing product: \(productId.rawValue)")
                }
            }
        }
    }

    func restorePurchases(completion: ValidationCompletion?) {
        self.inAppPurchaseService.restorePurchases { [weak self] purchases in
            guard let self = self else { return }
            guard let purchase = purchases.last(where: { $0.productId == self.monthlyProductItem.id.rawValue }) else {
                completion?(.noProductToValidate)
                return
            }
            ServiceLocator.shared.securityStorage.save(string: purchase.productId, forKey: SecurityStorage.Key.productIdSubscription.rawValue)
            self.validateSubscription { result in
                completion?(result)
            }
        }
    }

    func validateSubscription(_ completion: ValidationCompletion?) {
        guard let productId = ServiceLocator.shared.securityStorage.getString(
                forKey: SecurityStorage.Key.productIdSubscription.rawValue
        ) else {
            completion?(.noProductToValidate)
            return
        }

        guard let product = self.products[productId], product.id != .oneTimeTip else {
            appAssertionFailure("No product for product id: \(productId)")
            completion?(.error(MunaError.wrongProductForValidation))
            return
        }

        self.inAppRecieptValidationService.validateSubscription(forProduct: product) { result in
            switch result {
            case let .success(successResult):
                switch successResult {
                case let .expired(expiryDate, _):
                    ServiceLocator.shared.securityStorage.save(
                        bool: false,
                        forKey: SecurityStorage.Key.isUserPro.rawValue
                    )
                    ServiceLocator.shared.securityStorage.remove(
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
                    ServiceLocator.shared.securityStorage.save(
                        double: expiryDate.timeIntervalSince1970,
                        for: SecurityStorage.Key.expiredDate.rawValue
                    )
                    completion?(.expired)
                case .notPurchased:
                    ServiceLocator.shared.securityStorage.save(
                        bool: false,
                        forKey: SecurityStorage.Key.isUserPro.rawValue
                    )
                    ServiceLocator.shared.securityStorage.remove(
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
                    completion?(.notPurchased)
                case let .purchased(_, items):
                    ServiceLocator.shared.securityStorage.save(
                        bool: true,
                        forKey: SecurityStorage.Key.isUserPro.rawValue
                    )
                    guard let item = items.first(where: { item in
                        guard let expirationDate = item.subscriptionExpirationDate else {
                            return false
                        }

                        return expirationDate.timeIntervalSince1970 > Date().timeIntervalSince1970
                    }) else {
                        completion?(.purchased)
                        return
                    }
                    ServiceLocator.shared.securityStorage.save(
                        string: item.productId,
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
                    ServiceLocator.shared.securityStorage.save(
                        double: item.subscriptionExpirationDate?.timeIntervalSince1970,
                        for: SecurityStorage.Key.expirationDate.rawValue
                    )
                    completion?(.purchased)
                }
            case let .failure(error):
                appAssertionFailure("Error on subscription validation: \(error)")
                completion?(.error(error))
            case .noProductToValidate:
                completion?(.noProductToValidate)
            }
        }
    }

    func isNeededToShowTips() -> Bool {
        guard ServiceLocator.shared.itemsDatabase.fetchNumberOfCompletedItems() > 4 else {
            return false
        }

        let isUserPro = ServiceLocator.shared.securityStorage.getBool(forKey: SecurityStorage.Key.isUserPro.rawValue) ?? false
        
        guard !isUserPro else {
            return false
        }

        let expiredDate = ServiceLocator.shared.securityStorage.getDouble(forKey: SecurityStorage.Key.expiredDate.rawValue)
        let oneTimeTipDate = ServiceLocator.shared.securityStorage.getDouble(forKey: SecurityStorage.Key.purchaseTipDate.rawValue)

        let oneMonthInSeconds = PresentationLayerConstants.oneMonthInSeconds
        
        let isExpirationValidForShowing: Bool
        let isTipsPayDateValidForShowing: Bool
        
        if let expiredDate = expiredDate {
            let dateSinceExpiration = Date().timeIntervalSince1970 - expiredDate
            if dateSinceExpiration > oneMonthInSeconds {
                isExpirationValidForShowing = true
            } else {
                isExpirationValidForShowing = false
            }
        } else {
            isExpirationValidForShowing = true
        }

        if let oneTimeTipDate = oneTimeTipDate {
            let dateSinceTip = Date().timeIntervalSince1970 - oneTimeTipDate
            if dateSinceTip > oneMonthInSeconds * 4 {
                isTipsPayDateValidForShowing = true
            } else {
                isTipsPayDateValidForShowing = false
            }
        } else {
            isTipsPayDateValidForShowing = true
        }

        return isExpirationValidForShowing && isTipsPayDateValidForShowing
    }
}
