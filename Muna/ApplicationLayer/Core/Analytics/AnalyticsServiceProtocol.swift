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

    func update(userId: String)

    var deviceId: String? { get }
    func buildCohortPair() -> CohortPair

    func logEvent(name: String, properties: [AnyHashable: AnalyticsValueProtocol]?)
    func logEvent(name: String)

    func logEventOnce(name: String, properties: [AnyHashable: AnalyticsValueProtocol]?)
    func logEventOnce(name: String)

    func setPersonProperty(name: String, value: AnalyticsValueProtocol)
    func setPersonPropertyOnce(name: String, value: AnalyticsValueProtocol)

    func increasePersonProperty(name: String, by value: Int)

    func loggedOnceValue(for key: String) -> NSObject?
}
