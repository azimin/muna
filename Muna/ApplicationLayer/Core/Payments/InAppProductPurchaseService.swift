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
    var checkTransactions: (([Purchase]) -> Void)?

    func buyProduct(_ product: SKProduct, completion: @escaping (Result<PurchaseDetails, SKError>) -> Void) {
        SwiftyStoreKit.purchaseProduct(product) { result in
            switch result {
            case let .success(purchase):
                SwiftyStoreKit.finishTransaction(purchase.transaction)
                OperationQueue.main.addOperation {
                    completion(.success(purchase))
                }
            case let .error(error):
                OperationQueue.main.addOperation {
                    completion(.failure(error))
                }
            }
        }
    }

    func restorePurchases(completion: @escaping ([Purchase]) -> Void) {
        SwiftyStoreKit.restorePurchases { [weak self] results in
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            self?.checkTransactions?(results.restoredPurchases)
            completion(results.restoredPurchases)
        }
    }

    func completeTransactions() {
        SwiftyStoreKit.completeTransactions { [weak self] purchases in
            for purchase in purchases {
                // Deliver content from server, then:
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }

            self?.checkTransactions?(purchases)
        }
    }
}
