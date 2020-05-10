//
//  Preferences.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import MASShortcut

class Preferences {
    static var defaultShortcutUDKey = "ud_activation_shortcut"
    static var defaultShortcutScreenshotKey = "screenshot_full_short"

    static var defaultUserDefaults: [String: NSObject] {
        // cmd + shift + t

        let defaultActivationShortcut = ShortcutItem(
            key: .t,
            modifiers: [.command, .shift]
        ).masShortcut

        // cmd + shift + s
        let defaultScreensshotShortcut = ShortcutItem(
            key: .s,
            modifiers: [.command, .shift]
        ).masShortcut

        var result: [String: NSObject] = [:]

        if let shortcut = defaultActivationShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutUDKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutUDKey)
        }

        if let shortcut = defaultScreensshotShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutScreenshotKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutScreenshotKey)
        }

        return result
    }
}
