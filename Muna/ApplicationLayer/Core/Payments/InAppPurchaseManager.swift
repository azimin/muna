//
//  InAppPurchaseManager.swift
//  Muna
//
//  Created by Egor Petrov on 08.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

final class InAppPurchaseManager {

    private let monthlyProductItem = InAppProductItem(id: ProductIds.monthly.rawValue)

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
}
