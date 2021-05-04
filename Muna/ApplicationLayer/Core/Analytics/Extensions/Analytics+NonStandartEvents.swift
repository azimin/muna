//
//  Analytics+NonStandartEvents.swift
//  Muna
//
//  Created by Alexander on 5/3/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

enum AnalyticsPurhcaseState: String {
    case started
    case finished
    case failed
    case cancelled
}

extension AnalyticsServiceProtocol {
    func logShowWindow(name: String) {
        self.logEvent(name: "Show Window", properties: [
            "type": name,
        ])
    }

    func logTipGiven(isSubscription: Bool) {
        self.logEvent(name: "Gave Tip", properties: [
            "type": isSubscription ? "subscription" : "one_time_purchase",
        ])

        self.setPersonProperty(
            name: "supporter",
            value: true
        )
    }

    func logPurchaseState(state: AnalyticsPurhcaseState, message: String? = nil) {
        if let message = message {
            self.logEvent(name: "Purchase State", properties: [
                "state": state.rawValue,
                "message": message
            ])
        } else {
            self.logEvent(name: "Purchase State", properties: [
                "state": state.rawValue
            ])
        }
    }
}
