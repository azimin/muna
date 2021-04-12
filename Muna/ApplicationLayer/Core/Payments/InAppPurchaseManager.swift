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
        case error(Error)
    }

    enum PurchaseState {
        case purchased
        case cancelled
        case error(Error)
    }

    typealias PurchaseCompletion = (PurchaseState) -> Void
    typealias ValidationCompletion = (ValidationState) -> Void

    private var monthlyProductItem = InAppProductItem(id: ProductIds.monthly, productType: .subscription)
    private var oneTimeTipProductItem = InAppProductItem(id: ProductIds.oneTimeTip, productType: .oneTime)

    var products: [String: InAppProductItem] {
        return [
            ProductIds.monthly.rawValue: self.monthlyProductItem,
            ProductIds.oneTimeTip.rawValue: self.oneTimeTipProductItem
        ]
    }

    private let inAppProductsService: InAppProductsService
    private let inAppPurchaseService: InAppProductPurchaseService
    private let inAppRecieptValidationService: InAppRecieptValidationService

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

    func loadProducts(_ completion: VoidBlock? = nil) {
        self.inAppProductsService.requestProducts(forIds: [.monthly, .oneTimeTip]) {
            switch $0 {
            case let .requested(products):
                self.monthlyProductItem.product = products.first(where: { $0.productIdentifier ==  ProductIds.monthly.rawValue })
                self.oneTimeTipProductItem.product = products.first(where: { $0.productIdentifier ==  ProductIds.oneTimeTip.rawValue })
                completion?()
            case let .failed(error):
                appAssertionFailure("Error on loading products: \(error)")
            default:
                break
            }
        }
    }

    func buyProduct(_ productId: ProductIds, completion: @escaping PurchaseCompletion) {
        guard let inAppItem = self.products[productId.rawValue], let product = inAppItem.product else {
            self.loadProducts { [weak self] in
                self?.buyProduct(productId, completion: completion)
            }
            return
        }

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
                    self?.validateSubscription { result in
                        switch result {
                        case .purchased:
                            completion(.purchased)
                        default:
                            break
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

    func restorePurchases(completion: VoidBlock?) {
        self.inAppPurchaseService.restorePurchases(completion: completion)
    }

    func validateSubscription(_ completion: ValidationCompletion?) {
        guard let productId = ServiceLocator.shared.securityStorage.getString(
                forKey: SecurityStorage.Key.productIdSubscription.rawValue
        ) else {
            return
        }

        guard let product = self.products[productId], product.id != .oneTimeTip else {
            appAssertionFailure("No product for product id: \(productId)")
            return
        }

        self.inAppRecieptValidationService.validateSubscription(forProduct: product) { result in
            switch result {
            case let .success(successResult):
                switch successResult {
                case .expired:
                    ServiceLocator.shared.securityStorage.save(
                        bool: false,
                        forKey: SecurityStorage.Key.isUserPro.rawValue
                    )
                    ServiceLocator.shared.securityStorage.remove(
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
                    ServiceLocator.shared.securityStorage.save(
                        double: Date().timeIntervalSince1970,
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
                    items.forEach { item in
                        ServiceLocator.shared.securityStorage.save(
                            string: item.productId,
                            forKey: SecurityStorage.Key.productIdSubscription.rawValue
                        )
                        ServiceLocator.shared.securityStorage.save(
                            double: item.subscriptionExpirationDate?.timeIntervalSince1970,
                            for: SecurityStorage.Key.expirationDate.rawValue
                        )
                    }
                    completion?(.purchased)
                }
            case let .failure(error):
                appAssertionFailure("Error on subscription validation: \(error)")
                completion?(.error(error))
            }
        }
    }
}
