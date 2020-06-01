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
    static var defaultShortcutPanelKey = "ud_activation_shortcut"
    static var defaultShortcutScreenshotKey = "screenshot_part_short"
    static var defaultShortcutDebugKey = "ud_activation_debug_shortcut"
    static var defaultShortcutFullscreenScreenshotKey = "screenshot_full_short"

    static var defaultScreenshotShortcutItem = ShortcutItem(
        key: .two,
        modifiers: [.command, .shift]
    )

    static var defaultUserDefaults: [String: NSObject] {
        // cmd + shift + w
        let defaultActivationShortcut = ShortcutItem(
            key: .w,
            modifiers: [.command, .shift]
        ).masShortcut

        // cmd + shift + 2
        let defaultScreenshotShortcut = defaultScreenshotShortcutItem.masShortcut

        // cmd + shift + 1
        let defaultShortcutFullscreenScreenshotShortcut = ShortcutItem(
            key: .one,
            modifiers: [.command, .shift]
        )
        .masShortcut

        // cmd + shift + d
        let defaultDebugShortcut = ShortcutItem(
            key: .d,
            modifiers: [.command, .shift]
        ).masShortcut

        var result: [String: NSObject] = [:]

        if let shortcut = defaultActivationShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutPanelKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutPanelKey)
        }

        if let shortcut = defaultScreenshotShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutScreenshotKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutScreenshotKey)
        }

        if let shortcut = defaultDebugShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutDebugKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutDebugKey)
        }

        if let shortcut = defaultShortcutFullscreenScreenshotShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            ) {
            result[Preferences.defaultShortcutFullscreenScreenshotKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutFullscreenScreenshotKey)
        }

        return result
    }
}
