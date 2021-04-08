//
//  SecurityStorage.swift
//  Muna
//
//  Created by Egor Petrov on 14.01.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation
import KeychainAccess

final class SecurityStorage: StorageServiceProtocol {
    enum Key: String {
        case isUserPro
        case productIdSubscription
        case purchaseTipDate
        case expiredDate
        case expirationDate
    }

    let keychain = Keychain(service: "com.abstract.muna")

    func save(string: String?, forKey key: String) {
        guard let string = string else {
            appAssertionFailure("Security storage allows to save only non-optional string")
            return
        }
        do {
            try keychain.set(string, key: key)
        } catch {
            appAssertionFailure("Error while saving string to security storage: \(error)")
        }
    }

    func getString(forKey key: String) -> String? {
        do {
           return try self.keychain.getString(key)
        } catch {
            appAssertionFailure("Error while getting string from security storage: \(error)")
            return nil
        }
    }

    func save(int: Int?, forKey key: String) {
        guard let int = int else {
            appAssertionFailure("Security storage allows to save only non-optional int")
            return
        }
        do {
           return try keychain.set("\(int)", key: key)
        } catch {
            appAssertionFailure("Error while int to security storage: \(error)")
        }
    }

    func getInt(forKey key: String) -> Int? {
        do {
            return try Int(self.keychain.getString(key) ?? "")
        } catch {
            appAssertionFailure("Error while getting string from security storage: \(error)")
            return nil
        }
    }

    func save(bool: Bool?, forKey key: String) {
        guard let bool = bool else {
            appAssertionFailure("Security storage allows to save only non-optional bool")
            return
        }
        do {
            try keychain.set("\(bool)", key: key)
        } catch {
            appAssertionFailure("Error while bool to security storage: \(error)")
        }
    }

    func getBool(forKey key: String) -> Bool? {
        do {
            return try Bool(self.keychain.getString(key) ?? "")
        } catch {
            appAssertionFailure("Error while getting string from security storage: \(error)")
            return nil
        }
    }

    func save(double: Double?, for key: String) {
        guard let double = double else {
            appAssertionFailure("Security storage allows to save only non-optional double")
            return
        }
        do {
            try keychain.set("\(double)", key: key)
        } catch {
            appAssertionFailure("Error while bool to security storage: \(error)")
        }
    }

    func getDouble(forKey key: String) -> Double? {
        do {
            return try Double(self.keychain.getString(key) ?? "")
        } catch {
            appAssertionFailure("Error while getting double from security storage: \(error)")
            return nil
        }
    }

    func save(object: NSObject?, for key: String) {
        appAssertionFailure("Not implemented")
    }

    func getObject(forKey key: String) -> NSObject? {
        appAssertionFailure("Not implemented")
        return nil
    }

    func saveGenericObject<T>(object: T, for key: String) where T: Decodable, T: Encodable {
        appAssertionFailure("Not implemented")
    }

    func getGenericObject<T>(object: T.Type, for key: String) -> T? where T: Decodable, T: Encodable {
        appAssertionFailure("Not implemented")
        return nil
    }

    func remove(forKey key: String) {
        do {
            try self.keychain.remove(key)
        } catch {
            appAssertionFailure("Error while deleting an object: \(error)")
        }
    }
}
