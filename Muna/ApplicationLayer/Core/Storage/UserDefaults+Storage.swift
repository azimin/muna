//
//  UserDefaults+Storage.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension UserDefaults: StorageServiceProtocol {
    public func save(object: NSObject?, for key: String) {
        self.setValue(object, forKey: key)
        self.synchronize()
    }

    public func getObject(forKey key: String) -> NSObject? {
        return self.object(forKey: key) as? NSObject
    }

    public func saveGenericObject<T>(object: T, for key: String) where T: Decodable, T: Encodable {
        let data = object.toJson()
        self.set(data, forKey: key)
    }

    public func getGenericObject<T>(object: T.Type, for key: String) -> T? where T: Decodable, T: Encodable {
        guard let data = self.object(forKey: key) as? Data else {
            return nil
        }

        return try? T.from(jsonData: data)
    }

    public func save(string: String?, forKey key: String) {
        self.set(string, forKey: key)
        self.synchronize()
    }

    public func getString(forKey key: String) -> String? {
        return self.object(forKey: key) as? String
    }

    public func save(int: Int?, forKey key: String) {
        self.set(int, forKey: key)
        self.synchronize()
    }

    public func getInt(forKey key: String) -> Int? {
        return self.object(forKey: key) as? Int
    }

    public func save(bool: Bool?, forKey key: String) {
        self.set(bool, forKey: key)
        self.synchronize()
    }

    public func getBool(forKey key: String) -> Bool? {
        return self.object(forKey: key) as? Bool
    }

    public func remove(forKey key: String) {
        self.removeObject(forKey: key)
    }
}

extension Decodable {
    static func from(jsonData data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

extension Encodable {
    func toJson() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
