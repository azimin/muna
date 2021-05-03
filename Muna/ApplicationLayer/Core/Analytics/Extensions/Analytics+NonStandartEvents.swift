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
}
