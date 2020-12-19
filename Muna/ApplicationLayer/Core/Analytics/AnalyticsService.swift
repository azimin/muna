//
//  AnalyticsService.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Amplitude
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Foundation

public class AnalyticsService: AnalyticsServiceProtocol {
    private let storage: StorageServiceProtocol
    private var apmplitudeId: String?
    private var additionalServices: [AnalyticsAdditionalServiceProtocol]

    public init(
        storage: StorageServiceProtocol,
        apmplitudeId: String?,
        additionalServices: [AnalyticsAdditionalServiceProtocol]
    ) {
        self.storage = storage
        self.apmplitudeId = apmplitudeId
        self.additionalServices = additionalServices

        if let id = apmplitudeId {
            Amplitude.instance().initializeApiKey(id)
            Amplitude.instance().trackingSessionEvents = true
            Amplitude.instance().setUserId(self.userId, startNewSession: true)
            AppCenter.start(withAppSecret: "6b14925b-9fe0-4d27-a949-a3f0625a538a", services: [
                Analytics.self,
                Crashes.self,
            ])
            #if DEBUG
                Amplitude.instance().optOut = true
            #else
                Amplitude.instance().optOut = false
            #endif
        }

        self.additionalServices.forEach { $0.setup(id: self.userId) }
    }

    public func update(userId: String) {
        Amplitude.instance().setUserId(userId, startNewSession: true)
        self.additionalServices.forEach { $0.setup(id: userId) }
    }

    public var userId: String {
        var id: String
        if let cachedId = self.storage.getString(forKey: "generated-auth0-user-id") {
            id = cachedId
        } else {
            let newId = UUID().uuidString
            self.storage.save(string: newId, forKey: "generated-auth0-user-id")
            id = newId
        }
        return id
    }

    public var deviceId: String? {
        return Amplitude.instance().getDeviceId()
    }

    public func buildCohortPair() -> AnalyticsServiceProtocol.CohortPair {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.ordinality(of: .day, in: .year, for: Date())
        return (day ?? 0, weekOfYear, month)
    }

    public func logEvent(name: String, properties: [AnyHashable: AnalyticsValueProtocol]? = nil) {
        let propertiesObjects = properties?.mapValues { $0.analyticsValue }

        if let propertiesObjects = propertiesObjects {
            Amplitude.instance().logEvent(name, withEventProperties: propertiesObjects)
        } else {
            Amplitude.instance().logEvent(name)
        }
        self.additionalServices.forEach { $0.logEvent(name: name, properties: propertiesObjects) }

        #if DEBUG
            if let propertiesValue = propertiesObjects {
                print("Log Event: \(name)", propertiesValue)
            } else {
                print("Log Event: \(name)")
            }
        #endif
    }

    public func logEvent(name: String) {
        self.logEvent(name: name, properties: nil)
    }

    public func logEventOnce(name: String, properties: [AnyHashable: AnalyticsValueProtocol]? = nil) {
        let udKey = self.storageEventKey(with: name)
        if self.storage.getBool(forKey: udKey) == true {
            return
        }

        self.logEvent(name: name, properties: properties)
        self.storage.save(bool: true, forKey: udKey)
    }

    public func logEventOnce(name: String) {
        self.logEventOnce(name: name, properties: nil)
    }

    public func setPersonProperty(name: String, value: AnalyticsValueProtocol) {
        let object = value.analyticsValue

        if let identify = AMPIdentify().set(name, value: object) {
            Amplitude.instance().identify(identify)
        }
        self.additionalServices.forEach { $0.setPersonProperty(name: name, value: object) }

        #if DEBUG
            print("Set person property: \(name) - \(value)")
        #endif
    }

    public func setPersonPropertyOnce(name: String, value: AnalyticsValueProtocol) {
        let object = value.analyticsValue

        if let identify = AMPIdentify().setOnce(name, value: object) {
            Amplitude.instance().identify(identify)
        }

        let udKey = self.storageUserPropertiesKey(with: name)
        if self.storage.getBool(forKey: udKey) == nil {
            // ONEDAY: - Rething logic if completion would be false
            self.additionalServices.forEach { $0.setPersonProperty(name: name, value: object) }
            self.storage.save(bool: true, forKey: udKey)

            let udValueKey = self.storageUserPropertiesValueKey(with: name)
            self.storage.save(object: object, for: udValueKey)

            #if DEBUG
                print("Set person property once: \(name) - \(value)")
            #endif
        }
    }

    public func increasePersonProperty(name: String, by value: Int) {
        if let identify = AMPIdentify().add(name, value: value as NSObject) {
            Amplitude.instance().identify(identify)
        }

        let udKey = self.storageUserPropertiesKey(with: name)
        let storedValue = self.storage.getInt(forKey: udKey)
        var newValue: Int = storedValue ?? 0
        newValue += value
        self.storage.save(int: newValue, forKey: udKey)
        self.additionalServices.forEach { $0.setPersonProperty(name: name, value: "\(value)" as NSObject) }

        #if DEBUG
            print("Increase person property: \(name) - \(value)")
        #endif
    }

    public func loggedOnceValue(for key: String) -> NSObject? {
        return self.storage.getObject(forKey: self.storageUserPropertiesValueKey(with: key))
    }

    // MARK: - Helpers

    private func convertToFB(properties: [AnyHashable: Any]) -> [String: Any] {
        var parameters: [String: Any] = [:]
        for (key, value) in properties {
            if let key = key as? String {
                parameters[key] = value
            }
        }
        return parameters
    }

    private func storageUserPropertiesKey(with name: String) -> String {
        return "_analytics-reports.up.\(name)"
    }

    private func storageUserPropertiesValueKey(with name: String) -> String {
        return "_analytics-reports.up.value.\(name)"
    }

    private func storageEventKey(with name: String) -> String {
        return "_analytics-reports.event.\(name)"
    }
}
