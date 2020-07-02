//
//  UserDefaultsEntry.swift
//  Muna
//
//  Created by Egor Petrov on 02.07.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsEntry<T, Key: RawRepresentable> where Key.RawValue: StringProtocol {
    let key: Key
    let defaultValue: () -> T
    let defaults: UserDefaults = .standard

    init(wrappedValue: @escaping @autoclosure () -> T, key: Key) {
        self.key = key
        self.defaultValue = wrappedValue
    }

    var wrappedValue: T {
        get {
            return self.defaults.object(forKey: self.key.rawValue.description) as? T ?? self.defaultValue()
        }

        set {
            self.defaults.set(newValue, forKey: self.key.rawValue.description)
            self.defaults.synchronize()
        }
    }
}

@propertyWrapper
struct RawRepresentableUserDefaultsEntry<T: RawRepresentable, Key: RawRepresentable> where Key.RawValue: StringProtocol {
    let key: Key
    let defaultValue: () -> T
    let defaults: UserDefaults = .standard

    init(wrappedValue: @escaping @autoclosure () -> T, key: Key) {
        self.key = key
        self.defaultValue = wrappedValue
    }

    var wrappedValue: T {
        get {
            let rawValue = self.defaults.object(forKey: self.key.rawValue.description) as? T.RawValue
            return rawValue.flatMap(T.init) ?? self.defaultValue()
        }

        set {
            self.defaults.set(newValue.rawValue, forKey: self.key.rawValue.description)
        }
    }
}
