//
//  Analytics+NonStandartEvents.swift
//  Muna
//
//  Created by Alexander on 5/3/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

extension AnalyticsServiceProtocol {
    func logShowWindow(name: String) {
        ServiceLocator.shared.analytics.logEvent(name: "Show Window", properties: [
            "type": name,
        ])
    }

    func logTipGiven(isSubscription: Bool) {
        ServiceLocator.shared.analytics.logEvent(name: "Gave Tip", properties: [
            "type": isSubscription ? "subscription" : "one_time_purchase",
        ])

        ServiceLocator.shared.analytics.setPersonProperty(
            name: "supporter",
            value: true
        )
    }
}
