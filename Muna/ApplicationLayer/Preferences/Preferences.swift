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
        let defaultActivationShortcut = MASShortcut(
            keyCode: 17,
            modifierFlags: [.command, .shift]
        )

        let defaultScreensshotShortcut = MASShortcut(
            keyCode: 1,
            modifierFlags: [.command, .shift]
        )

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
