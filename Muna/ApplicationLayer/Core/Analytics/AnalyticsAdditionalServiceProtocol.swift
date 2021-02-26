//
//  AnalyticsAdditionalServiceProtocol.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public protocol AnalyticsAdditionalServiceProtocol {
    func setup(id: String)
    func logEvent(name: String, properties: [String: Any]?)
    func logEventOnce(name: String, properties: [String: Any]?)
    func setOnce(name: String, value: NSObject)
    func setPersonProperty(name: String, value: NSObject)
    func addPersonProperty(name: String, by value: Int)
}
