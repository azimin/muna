//
//  InAppProductsService.swift
//  Muna
//
//  Created by Egor Petrov on 07.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import StoreKit

final class InAppProductsService: NSObject {
    enum Status {
        case none
        case requesting(SKProductsRequest)
        case requested([SKProduct])
        case failed(Error)
    }

    private(set) var status: Status = .none {
        didSet {
            self.onStatusChanged?(self.status)
        }
    }

    private var onStatusChanged: ((Status) -> Void)?

    func requestProducts(forIds ids: [String], _ onCompletion: ((Status) -> Void)?) {
        switch self.status {
        case .requesting:
            return
        default:
            break
        }

        let skRequest = SKProductsRequest(productIdentifiers: Set(ids))
        skRequest.delegate = self

        self.status = .requesting(skRequest)

        skRequest.start()
    }
}

extension InAppProductsService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.status = .requested(response.products)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.status = .failed(error)
    }
}
