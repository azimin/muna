//
//  InAppRecieptValidator.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import SwiftyStoreKit

final class InAppRecieptValidationService {
    enum State {
        case noProductToValidate
        case success(VerifySubscriptionResult)
        case failure(ReceiptError)
    }

    func validateSubscription(forProduct product: InAppProductItem, _ completion: @escaping (State) -> Void) {
        let recieptValidator: AppleReceiptValidator

        #if DEBUG
        recieptValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "63f46b0bd1c944119be1b74d18c8509d")
        #else
        recieptValidator = AppleReceiptValidator(service: .production, sharedSecret: "63f46b0bd1c944119be1b74d18c8509d")
        #endif
        
        SwiftyStoreKit.verifyReceipt(using: recieptValidator) { result in
            switch result {
            case let .success(receipt):
                guard product.id == .monthly else {
                    completion(.noProductToValidate)
                    return
                }
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: product.id.rawValue,
                    inReceipt: receipt
                )
                completion(.success(purchaseResult))
            case let .error(error):
                completion(.failure(error))
            }
        }
    }
}
