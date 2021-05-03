//
//  Analytics+Debug.swift
//  Muna
//
//  Created by Alexander on 5/3/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

// MARK: - DebugAnalytics

protocol DebugLogAnalyticsProtocol {
    func log(_ string: String)
}

extension DebugLogAnalyticsProtocol {
    private func log(_ logger: ((String) -> Void) -> Void) {
        var string: String = ""
        let append: (String) -> Void = {
            if string.isEmpty {
                string = $0
            } else {
                string += "\n\($0)"
            }
        }
        logger(append)
        self.log(string)
    }
}

extension DebugLogAnalyticsProtocol {

    func setUserId(_ userId: String) {
        self.log { logger in
            logger("Update user id: \(userId)")
        }
    }

    var deviceId: String {
        self.log { logger in
            logger("Request device id")
        }
        return ""
    }

    func logEvent(name: String, properties: [String: AnalyticsValueProtocol]?) {
        self.log { logger in
            logger("Log event: \(name)")
            if let properties = properties, properties.isEmpty == false {
                logger(properties.asJSON())
            }
        }
    }

    func logEventOnce(name: String, properties: [String: AnalyticsValueProtocol]?) {
        self.log { logger in
            logger("Log event once: \(name)")
            if let properties = properties, properties.isEmpty == false {
                logger(properties.asJSON())
            }
        }
    }

    func setUserProperty(name: String, value: AnalyticsValueProtocol) {
        self.log { logger in
            logger("Set person property: \(name) → \(value)")
        }
    }

    func setUserPropertyOnce(name: String, value: AnalyticsValueProtocol) {
        self.log { logger in
            logger("Set person property once: \(name) → \(value)")
        }
    }

    func increaseUserProperty(name: String, by value: Int) {
        self.log { logger in
            logger("Increase person property: \(name) \(value >= 0 ? "+" : "")\(value)")
        }
    }
}

// MARK: - Xcode log

final class DebugXcodeLogAnalytics: DebugLogAnalyticsProtocol {
    func log(_ string: String) {
        print("📊", string)
    }
}

fileprivate extension Dictionary where Key == String, Value == AnalyticsValueProtocol {
    func asJSON() -> String {
        let dict = self.mapValues { $0.analyticsValue as Any }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys, .prettyPrinted]) else {
            appAssertionFailure("Can't convert dict to json string: \(self)")
            return ""
        }
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
}
