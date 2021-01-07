//
//  InAppProductPurchaseService.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import StoreKit
import SwiftyStoreKit

final class InAppProductPurchaseService {
    func buyProduct(_ product: SKProduct, completion: @escaping (Result<PurchaseDetails, SKError>) -> Void) {
        SwiftyStoreKit.purchaseProduct(product) { result in
            switch result {
            case let .success(purchase):
                completion(.success(purchase))
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            case let .error(error):
                completion(.failure(error))
            }
        }
    }

    func restorePurchases(_ competion: @escaping ([Purchase]) -> Void) {
        SwiftyStoreKit.restorePurchases { results in
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                // Deliver content from server, then:
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
        }
    }
}
