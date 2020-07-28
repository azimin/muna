//
//  AppDelegate+Analytics.swift
//  Muna
//
//  Created by Alexander on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension AppDelegate {
    func logAnalytics() {
        let pair = ServiceLocator.shared.analytics.buildCohortPair()
        ServiceLocator.shared.analytics.setPersonPropertyOnce(
            name: "cohort_day",
            value: pair.cohortDay
        )
        ServiceLocator.shared.analytics.setPersonPropertyOnce(
            name: "cohort_week",
            value: pair.cohortWeek
        )
        ServiceLocator.shared.analytics.setPersonPropertyOnce(
            name: "cohort_month",
            value: pair.cohortMonth
        )
        ServiceLocator.shared.analytics.setPersonPropertyOnce(
            name: "device_id",
            value: ServiceLocator.shared.analytics.deviceId ?? ""
        )

        if let dictionary = Bundle.main.infoDictionary,
            let build = dictionary["CFBundleVersion"] as? String {
            ServiceLocator.shared.analytics.setPersonProperty(name: "build", value: build)
        }

        ServiceLocator.shared.analytics.logEventOnce(name: "App Launched First Time")
        ServiceLocator.shared.analytics.logEvent(name: "App Launched")
    }
}
