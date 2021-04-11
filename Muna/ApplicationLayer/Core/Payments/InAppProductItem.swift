//
//  InAppProductItem.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import StoreKit

struct InAppProductItem {
    enum ProductType {
        case oneTime
        case subscription
    }

    let id: ProductIds

    var product: SKProduct?
    
    let productType: ProductType

    init(id: ProductIds, productType: ProductType) {
        self.id = id
        self.productType = productType
    }

    mutating func addProduct(_ product: SKProduct) {
        self.product = product
    }
}
