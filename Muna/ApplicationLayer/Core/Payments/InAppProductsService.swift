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

    var skRequest: SKProductsRequest!

    func requestProducts(forIds ids: [ProductIds], _ onCompletion: ((Status) -> Void)?) {
        self.onStatusChanged = onCompletion
        switch self.status {
        case .requesting:
            return
        default:
            break
        }

        self.skRequest = SKProductsRequest(productIdentifiers: Set(ids.map { $0.rawValue }))
        self.skRequest.delegate = self

        self.status = .requesting(skRequest)

        self.skRequest.start()
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
