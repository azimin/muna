//
//  StorageServiceProtocol.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public protocol StorageServiceProtocol {
    func save(string: String?, forKey key: String)
    func getString(forKey key: String) -> String?

    func save(int: Int?, forKey key: String)
    func getInt(forKey key: String) -> Int?

    func save(bool: Bool?, forKey key: String)
    func getBool(forKey key: String) -> Bool?

    func save(object: NSObject?, for key: String)
    func getObject(forKey key: String) -> NSObject?

    func save(double: Double?, for key: String)
    func getDouble(forKey key: String) -> Double?

    func saveGenericObject<T: Codable>(object: T, for key: String)
    func getGenericObject<T: Codable>(object: T.Type, for key: String) -> T?

    func remove(forKey key: String)
}

public extension StorageServiceProtocol {
    func bool(for key: String) -> Bool {
        return (self.getBool(forKey: key) as Bool?) ?? false
    }

    func int(for key: String) -> Int {
        return (self.getInt(forKey: key) as Int?) ?? 0
    }

    func string(for key: String) -> String {
        return (self.getString(forKey: key) as String?) ?? ""
    }
}
