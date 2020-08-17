//
//  AppDelegate.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import LaunchAtLogin
import MASShortcut
import SwiftDate
import SwiftyChrono

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, AssertionErrorHandlerProtocol {
    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    lazy var windowManager = ServiceLocator.shared.windowManager

    func handleAssertion(error: NSError) {
        var properties: [AnyHashable: AnalyticsValueProtocol] = [:]

        for (key, value) in error.userInfo {
            if let fitValue = value as? AnalyticsValueProtocol {
                properties[key] = fitValue
            }
        }

        ServiceLocator.shared.analytics.logEvent(
            name: "Assertion",
            properties: properties
        )
        print(error)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ServiceLocator.shared = ServiceLocator(
            assertionHandler: AssertionHandler(assertionErrorHandler: self)
        )

//        AppDelegate.notificationCenter.delegate = self
//        AppDelegate.notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
//            if granted {
//                print("Approval granted to send notifications")
//                self.registerNotificationsActions()
//            } else if let error = error {
//                print(error)
//            }
//        }

        NSUserNotificationCenter.default.delegate = self

        TimeParserTests.test()

        self.setupUserDefaults()
        self.setupStatusBarItem()
        self.setupShortcuts()
        self.logAnalytics()
        self.scheduleMissingNotifications()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hidePanelIfNeeded),
            name: NSWindow.didResignKeyNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hideScreenshotIfNeeded),
            name: NSWindow.didResignKeyNotification,
            object: nil
        )

        Preferences.setup()

        if Preferences.isNeededToShowOnboarding || ServiceLocator.shared.betaKey.isEntered == false {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.onboarding)
        }

        let captureIsEnabled = ServiceLocator.shared.permissionsService.canRecordScreen
        ServiceLocator.shared.analytics.logCapturePermissions(isEnabled: captureIsEnabled)
    }

    func scheduleMissingNotifications() {
        for item in ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted) {
            if let date = item.dueDate, date.isInPast {
                self.pingNotificationSetup(itemId: item.id, onlyIfMissing: true)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ServiceLocator.shared.itemsDatabase.saveItems()

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutScreenshotKey
        )

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutPanelKey
        )

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutFullscreenScreenshotKey
        )
    }

    func setupUserDefaults() {
        UserDefaults.standard.register(defaults: Preferences.defaultUserDefaults)
    }

    func setupShortcuts() {
        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutPanelKey,
            toAction: {
                self.togglePane()
            }
        )

        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutScreenshotKey,
            toAction: {
                self.hideScreenshotIfNeeded()
                self.hideFullscreenScreenshotIfNeeded()
                self.toggleScreenshotState()
            }
        )

        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutFullscreenScreenshotKey,
            toAction: {
                self.hideScreenshotIfNeeded()
                self.hideFullscreenScreenshotIfNeeded()
                self.toogleFullscreenScreenshotState()
            }
        )

        #if DEBUG

            MASShortcutBinder.shared()?.bindShortcut(
                withDefaultsKey: Preferences.defaultShortcutDebugKey,
                toAction: {
                    self.windowManager.toggleWindow(.onboarding)
                }
            )

        #endif
    }

    func setupStatusBarItem() {
        let statusBar = NSStatusBar.system

        let statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )

        let image = NSImage(named: NSImage.Name("icon_menu"))
        image?.isTemplate = true
        statusBarItem.button?.image = image

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu

        self.statusBarItem = statusBarItem
        self.statusBarMenu = statusBarMenu

        let makeFullScreenshotItem = NSMenuItem(
            title: "Make Full-screenshot",
            action: #selector(self.toogleFullscreenScreenshotState),
            keyEquivalent: "1"
        )
        makeFullScreenshotItem.keyEquivalentModifierMask = [.shift, .command]
        statusBarMenu.addItem(makeFullScreenshotItem)

        let makeSelectedAreaScreenshot = NSMenuItem(
            title: "Make Selected Area Screenshot",
            action: #selector(self.toggleScreenshotState),
            keyEquivalent: "2"
        )
        makeSelectedAreaScreenshot.keyEquivalentModifierMask = [.shift, .command]
        statusBarMenu.addItem(makeSelectedAreaScreenshot)

        let item = NSMenuItem(
            title: "Show items",
            action: #selector(self.togglePane),
            keyEquivalent: "w"
        )
        item.keyEquivalentModifierMask = [.shift, .command]
        statusBarMenu.addItem(item)

        statusBarMenu.addItem(
            NSMenuItem.separator()
        )

        statusBarMenu.addItem(
            withTitle: "About Muna",
            action: #selector(self.togglePane),
            keyEquivalent: ""
        )

        statusBarMenu.addItem(
            withTitle: "Preference",
            action: #selector(self.toggleSettingsState),
            keyEquivalent: ","
        )

        statusBarMenu.addItem(
            NSMenuItem.separator()
        )

        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(self.closeApp),
            keyEquivalent: "q"
        )
    }

    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }

    @objc func hidePanelIfNeeded() {
        self.windowManager.hideWindowIfNeeded(.panel(selectedItem: nil))
    }

    @objc func hideScreenshotIfNeeded() {
        self.windowManager.hideWindowIfNeeded(.screenshot)
    }

    @objc func hideFullscreenScreenshotIfNeeded() {
        self.windowManager.hideWindowIfNeeded(.fullScreenshot)
    }

    @objc func togglePane() {
        self.windowManager.toggleWindow(.panel(selectedItem: nil))
    }

    @objc func toggleScreenshotState() {
        if ServiceLocator.shared.permissionsService.checkPermissions() {
            self.windowManager.toggleWindow(.screenshot)
        }
    }

    @objc func toogleFullscreenScreenshotState() {
        if ServiceLocator.shared.permissionsService.checkPermissions() {
            self.windowManager.toggleWindow(.fullScreenshot)
        }
    }

    @objc func toggleDebugState() {
        self.windowManager.toggleWindow(.debug)
    }

    @objc func toggleSettingsState() {
        self.windowManager.activateWindowIfNeeded(.settings)
    }

    // MARK: - User Notifications

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        guard let itemId = notification.userInfo?["item_id"] as? String else {
            appAssertionFailure("No item id")
            return
        }
        self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let itemId = notification.userInfo?["item_id"] as? String else {
            appAssertionFailure("No item id")
            return
        }

        print(notification.activationType.rawValue)
        switch notification.activationType {
        case .contentsClicked:
            self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                self.windowManager.activateWindowIfNeeded(.panel(selectedItem: item))
            } else {
                appAssertionFailure("No item by id")
            }
        case .actionButtonClicked:
            self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                self.windowManager.toggleWindow(.remindLater(item: item))
            } else {
                appAssertionFailure("No item by id")
            }
        default:
            break
        }
    }

    func pingNotificationSetup(itemId: String, onlyIfMissing: Bool) {
        if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId),
            let dueDate = item.dueDate {
            let sinceReminder = Date().timeIntervalSince(dueDate)

            let value: Preferences.PingInterval
            if let settingsValue = Preferences.PingInterval(rawValue: Preferences.pingInterval.lowercased()) {
                value = settingsValue
            } else {
                appAssertionFailure("Not supproted pingInterval: \(Preferences.pingInterval)")
                value = .fiveMins
            }

            switch value {
            case .fiveMins:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 5, onlyIfMissing: onlyIfMissing)
            case .tenMins:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 10, onlyIfMissing: onlyIfMissing)
            case .halfAnHour:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 30, onlyIfMissing: onlyIfMissing)
            case .hour:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 60, onlyIfMissing: onlyIfMissing)
            case .disabled:
                break
            }
        } else {
            appAssertionFailure("No item by id")
        }
    }
}
