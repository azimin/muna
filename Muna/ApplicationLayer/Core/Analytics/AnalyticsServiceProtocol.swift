//
//  AnalyticsServiceProtocol.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public protocol AnalyticsServiceProtocol {
    typealias CohortPair = (cohortDay: Int, cohortWeek: Int, cohortMonth: Int)

    func logLaunchEvents()

    func logEvent(name: String, properties: [String: AnalyticsValueProtocol]?)
    func logEventOnce(name: String, properties: [String: AnalyticsValueProtocol]?)

    func setPersonProperty(name: String, value: AnalyticsValueProtocol)
    func setPersonPropertyOnce(name: String, value: AnalyticsValueProtocol)

    func increasePersonProperty(name: String, by value: Int)
}

extension AnalyticsServiceProtocol {
    func logEvent(name: String) {
        self.logEvent(name: name, properties: nil)
    }

    func logEventOnce(name: String) {
        self.logEventOnce(name: name, properties: nil)
    }
}
