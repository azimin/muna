//
//  InAppProductItem.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import StoreKit

struct InAppProductItem {

    let id: ProductIds

    var product: SKProduct?

    init(id: ProductIds) {
        self.id = id
    }

    mutating func addProduct(_ product: SKProduct) {
        self.product = product
    }
}
