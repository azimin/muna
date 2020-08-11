//
//  BetaKeyService.swift
//  Muna
//
//  Created by Alexander on 8/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class BetaKeyService {
    var isEntered: Bool {
        return self.key != nil
    }

    var key: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "beta_key")

            if let value = newValue {
                ServiceLocator.shared.analytics.setPersonProperty(
                    name: "beta_key",
                    value: value
                )
            }
        }
        get {
            return UserDefaults.standard.string(forKey: "beta_key")
        }
    }

    func validate(key: String) -> Bool {
        return key == "11"
    }
}
