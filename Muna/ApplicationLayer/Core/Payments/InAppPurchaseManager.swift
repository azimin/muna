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

    private var monthlyProductItem = InAppProductItem(id: ProductIds.monthly.rawValue)

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
    }

    func completeTransaction() {
        self.inAppPurchaseService.completeTransactions()
    }

    func loadProducts(_ completion: VoidBlock? = nil) {
        self.inAppProductsService.requestProducts(forIds: [.monthly]) {
            switch $0 {
            case let .requested(products):
                self.monthlyProductItem.product = products.first
                completion?()
            case let .failed(error):
                appAssertionFailure("Error on loading products: \(error)")
            default:
                break
            }
        }
    }

    func buyProduct(_ productId: ProductIds) {
        guard let product = monthlyProductItem.product else {
            self.loadProducts { [weak self] in
                self?.buyProduct(productId)
            }
            return
        }

        self.inAppPurchaseService.buyProduct(product) { result in
            switch result {
            case let .success(purchaseDetails):
                ServiceLocator.shared.securityStorage.save(
                    bool: true,
                    forKey: SecurityStorage.Key.isUserPro.rawValue
                )
                ServiceLocator.shared.securityStorage.save(
                    string: purchaseDetails.productId,
                    forKey: SecurityStorage.Key.productIdSubscription.rawValue
                )
                if purchaseDetails.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseDetails.transaction)
                }
            case let .failure(error):
                appAssertionFailure("Error: \(error) on purchasing product: \(productId.rawValue)")
            }
        }
    }

    func restorePurchases() {
        self.inAppPurchaseService.restorePurchases()
    }

    func validateSubscription() {
        guard let productId = ServiceLocator.shared.securityStorage.getString(
                forKey: SecurityStorage.Key.productIdSubscription.rawValue
        ) else {
            return
        }
        self.inAppRecieptValidationService.validateSubscription(forProductId: productId) { result in
            switch result {
            case let .success(successResult):
                switch successResult {
                case .expired, .notPurchased:
                    ServiceLocator.shared.securityStorage.save(
                        bool: false,
                        forKey: SecurityStorage.Key.isUserPro.rawValue
                    )
                    ServiceLocator.shared.securityStorage.save(
                        string: nil,
                        forKey: SecurityStorage.Key.productIdSubscription.rawValue
                    )
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
                    }
                }
            case let .failure(error):
                appAssertionFailure("Error on subscription validation: \(error)")
            }
        }
    }
}
