//
//  Preferences.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import LaunchAtLogin
import MASShortcut

class Preferences {
    enum PingInterval: String, CaseIterable {
        case fiveMins = "once in 5 mins"
        case tenMins = "once in 10 mins"
        case halfAnHour = "once in 30 mins"
        case hour = "once in hour"
    }

    enum PeriodOfStoring: String, CaseIterable {
        case day
        case week
        case month
        case year
    }

    enum Key: String {
        case launchOnStartup
        case periodOfStoring
        case pingInterval
    }

    static var defaultShortcutPanelKey = "ud_activation_shortcut"
    static var defaultShortcutScreenshotKey = "screenshot_part_short"
    static var defaultShortcutDebugKey = "ud_activation_debug_shortcut"
    static var defaultShortcutFullscreenScreenshotKey = "screenshot_full_short"

    enum DefaultItems: ViewShortcutProtocol {
        case defaultScreenshotShortcut
        case defaultShortcutFullscreenScreenshotShortcut
        case defaultActivationShortcut

        var item: ShortcutItem {
            switch self {
            case .defaultShortcutFullscreenScreenshotShortcut:
                return ShortcutItem(
                    key: .one,
                    modifiers: [.command, .shift]
                )
            case .defaultScreenshotShortcut:
                return ShortcutItem(
                    key: .two,
                    modifiers: [.command, .shift]
                )
            case .defaultActivationShortcut:
                return ShortcutItem(
                    key: .w,
                    modifiers: [.command, .shift]
                )
            }
        }
    }

    static func setup() {
        if let value = ProcessInfo().environment["RESET_DEFAULTS"], value == "1" {
            self.resetDefaults()
        }
    }

    private static func resetDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

    static var defaultUserDefaults: [String: NSObject] {
        // cmd + shift + w
        let defaultActivationShortcut = DefaultItems.defaultActivationShortcut.item.masShortcut

        // cmd + shift + 2
        let defaultScreenshotShortcut = DefaultItems.defaultScreenshotShortcut.item.masShortcut

        // cmd + shift + 1
        let defaultShortcutFullscreenScreenshotShortcut = DefaultItems.defaultShortcutFullscreenScreenshotShortcut.item.masShortcut

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

    @UserDefaultsEntry(key: Key.launchOnStartup)
    static var launchOnStartup = false {
        didSet {
            LaunchAtLogin.isEnabled = self.launchOnStartup
        }
    }

    @UserDefaultsEntry(key: Key.periodOfStoring)
    static var periodOfStoring = PeriodOfStoring.week.rawValue

    @UserDefaultsEntry(key: Key.pingInterval)
    static var pingInterval = PingInterval.fiveMins.rawValue
}
