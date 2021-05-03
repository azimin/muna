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
        case disabled
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
        case isNeededToShowOnboarding
        case isFirstAskToPermissions
        case isNeededToShowAnalytics
        case splashOnThings
        case splashOnNotes
        case splashOnReminders
        case lastActiveTimeInterval
        case hintShowedForNotesTimeInterval
        case hintShowedForRemindersTimeInterval
        case shoulsUseAnalytics
        case isNeededToShowIncreaseProductivity
        case isFirstTimeOfShowingIncreaseProductivityPopup
        case isNeededToShowPassedItems
        case isAnalyticsEnabled
        case usedForcedLaunchAtLogin
    }

    static var defaultShortcutPanelKey = "ud_activation_shortcut"
    static var defaultShortcutVisualTaskKey = "screenshot_visual_test"
    static var defaultShortcutDebugKey = "ud_activation_debug_shortcut"
    static var defaultShortcutTextTaskKey = "screenshot_text_task"

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
                return Preferences.visualTaskShortcutItem ?? ShortcutItem(
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

    static var visualTaskShortcutItem: ShortcutItem? {
        guard let taskData = UserDefaults.standard.object(forKey: defaultShortcutVisualTaskKey) as? Data,
           let shortcut = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MASShortcut.self, from: taskData) else {
            return nil
        }

        return shortcut.item
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
            )
        {
            result[Preferences.defaultShortcutPanelKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutPanelKey)
        }

        if let shortcut = defaultScreenshotShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            )
        {
            result[Preferences.defaultShortcutVisualTaskKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutVisualTaskKey)
        }

        if let shortcut = defaultDebugShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            )
        {
            result[Preferences.defaultShortcutDebugKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutDebugKey)
        }

        if let shortcut = defaultShortcutFullscreenScreenshotShortcut,
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: shortcut,
                requiringSecureCoding: false
            )
        {
            result[Preferences.defaultShortcutTextTaskKey] = data as NSObject
            UserDefaults.standard.set(data, forKey: defaultShortcutTextTaskKey)
        }

        return result
    }

    @UserDefaultsEntry(wrappedValue: false, key: Key.usedForcedLaunchAtLogin)
    static var usedForcedLaunchAtLogin

    @UserDefaultsEntry(key: Key.launchOnStartup)
    static var launchOnStartup = false {
        didSet {
            if oldValue != self.launchOnStartup {
                ServiceLocator.shared.analytics.logLaunchOnStartup(
                    shouldLaunch: self.launchOnStartup
                )
            }

            LaunchAtLogin.isEnabled = self.launchOnStartup
        }
    }

    @UserDefaultsEntry(wrappedValue: false, key: Key.shoulsUseAnalytics)
    static var shouldUseAnalytics

    @UserDefaultsEntry(wrappedValue: PeriodOfStoring.week.rawValue, key: Key.periodOfStoring)
    static var periodOfStoring

    @UserDefaultsEntry(wrappedValue: PingInterval.fiveMins.rawValue, key: Key.pingInterval)
    static var pingInterval

    @UserDefaultsEntry(wrappedValue: true, key: Key.isNeededToShowOnboarding)
    static var isNeededToShowOnboarding

    @UserDefaultsEntry(wrappedValue: true, key: Key.isFirstAskToPermissions)
    static var isFirstAskToPermissions

    @UserDefaultsEntry(wrappedValue: true, key: Key.splashOnNotes)
    static var splashOnNotes

    @UserDefaultsEntry(wrappedValue: true, key: Key.splashOnThings)
    static var splashOnThings

    @UserDefaultsEntry(wrappedValue: true, key: Key.splashOnReminders)
    static var splashOnReminders

    static var storingPeriod: PeriodOfStoring {
        guard let periodOfStoring = PeriodOfStoring(rawValue: periodOfStoring) else {
            appAssertionFailure("Period of storing is not presented: \(Preferences.periodOfStoring)")
            return .month
        }
        return periodOfStoring
    }

    @UserDefaultsEntry(wrappedValue: Date().timeIntervalSince1970, key: Key.lastActiveTimeInterval)
    static var lastActiveTimeInterval

    @UserDefaultsEntry(wrappedValue: Date().timeIntervalSince1970, key: Key.hintShowedForNotesTimeInterval)
    static var hintShowedForNotesTimeInterval

    @UserDefaultsEntry(wrappedValue: Date().timeIntervalSince1970, key: Key.hintShowedForRemindersTimeInterval)
    static var hintShowedForRemindersTimeInterval

    @UserDefaultsEntry(wrappedValue: true, key: Key.isNeededToShowIncreaseProductivity)
    static var isNeededToShowIncreaseProductivity

    @UserDefaultsEntry(wrappedValue: true, key: Key.isFirstTimeOfShowingIncreaseProductivityPopup)
    static var isFirstTimeOfShowingIncreaseProductivityPopup

    @UserDefaultsEntry(wrappedValue: true, key: Key.isNeededToShowPassedItems)
    static var isNeededToShowPassedItems {
        didSet {
            if oldValue != self.isNeededToShowPassedItems {
                ServiceLocator.shared.analytics.logSetShowNumberOfUncomplitedItems(
                    isShow: self.isNeededToShowPassedItems
                )
            }
            NotificationCenter.default.post(name: .updateShowPassedItemSetting, object: nil)
        }
    }

    @UserDefaultsEntry(wrappedValue: true, key: Key.isNeededToShowAnalytics)
    static var isNeededToShowAnalytics
}
