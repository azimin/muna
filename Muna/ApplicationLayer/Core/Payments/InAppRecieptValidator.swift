//
//  InAppRecieptValidator.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import SwiftyStoreKit

final class InAppRecieptValidator {

    func validateSubscription(forProductId productId: String, _ completion: @escaping (Result<VerifySubscriptionResult, ReceiptError>) -> Void) {
        let recieptValidator: AppleReceiptValidator

        #if DEBUG
        recieptValidator = AppleReceiptValidator(service: .sandbox)
        #else
        recieptValidator = AppleReceiptValidator(service: .production)
        #endif

        SwiftyStoreKit.verifyReceipt(using: recieptValidator) { result in
            switch result {
            case let .success(receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt
                )
                completion(.success(purchaseResult))
            case let .error(error):
                completion(.failure(error))
            }
        }
    }
}
