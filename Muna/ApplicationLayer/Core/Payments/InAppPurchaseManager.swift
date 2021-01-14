//
//  InAppPurchaseManager.swift
//  Muna
//
//  Created by Egor Petrov on 08.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

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

    func loadProducts() {
        self.inAppProductsService.requestProducts(forIds: [.monthly]) {
            switch $0 {
            case let .requested(products):
                self.monthlyProductItem.product = products.first
            default:
                // TODO: Add loggging errors
                break
            }
        }
    }

    func buyProduct(_ productId: ProductIds) {
        guard let product = monthlyProductItem.product else {
            // TODO: Add product request
            return
        }

        self.inAppPurchaseService.buyProduct(product) { result in
            switch result {
            case let .success(purchaseDetails):
                // TODO: Save that user is pro
                break
            case let .failure(error):
                appAssertionFailure("Error: \(error) on purchasing product: \(productId.rawValue)")
            }
        }
    }

    func restorePurchases() {
        self.inAppPurchaseService.restorePurchases()
    }
}
