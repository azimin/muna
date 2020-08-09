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
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate, AssertionErrorHandlerProtocol {
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

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
            if granted {
                print("Approval granted to send notifications")
                self.registerNotificationsActions()
            } else if let error = error {
                print(error)
            }
        }

        TimeParserTests.test()

        self.registerNotificationsActions()
        self.setupUserDefaults()
        self.setupStatusBarItem()
        self.setupShortcuts()
        self.logAnalytics()

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

        if Preferences.isNeededToShowOnboarding {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.onboarding)
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
        self.windowManager.toggleWindow(.screenshot)
    }

    @objc func toogleFullscreenScreenshotState() {
        self.windowManager.toggleWindow(.fullScreenshot)
    }

    @objc func toggleDebugState() {
        self.windowManager.toggleWindow(.debug)
    }

    @objc func toggleSettingsState() {
        self.windowManager.activateWindowIfNeeded(.settings)
    }

    // MARK: - User Notifications

    func registerNotificationsActions() {
        let laterAction = UNNotificationAction(
            identifier: NotificationAction.later.rawValue,
            title: "Later",
            options: .foreground
        )

        let category = UNNotificationCategory(
            identifier: "item",
            actions: [laterAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let action: NotificationAction
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            action = .basicTap
        } else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            action = .dismiss
        } else {
            guard let type = NotificationAction(rawValue: response.actionIdentifier) else {
                completionHandler()
                return
            }
            action = type
        }

        guard let itemId = response.notification.request.content.userInfo["item_id"] as? String else {
            completionHandler()
            return
        }

        switch action {
        case .basicTap:
            self.pingNotificationSetup(itemId: itemId)
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                self.windowManager.activateWindowIfNeeded(.panel(selectedItem: item))
            } else {
                appAssertionFailure("No item by id")
            }
        case .complete:
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                item.isComplited = true
                ServiceLocator.shared.itemsDatabase.saveItems()
            } else {
                appAssertionFailure("No item by id")
            }
        case .later:
            self.pingNotificationSetup(itemId: itemId)
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                self.windowManager.toggleWindow(.remindLater(item: item))
            } else {
                appAssertionFailure("No item by id")
            }
        case .dismiss:
            self.pingNotificationSetup(itemId: itemId)
        }

        completionHandler()
    }

    func pingNotificationSetup(itemId: String) {
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
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 5)
            case .tenMins:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 10)
            case .halfAnHour:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 30)
            case .hour:
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: sinceReminder + 60 * 60)
            case .disabled:
                break
            }
        } else {
            appAssertionFailure("No item by id")
        }
    }
}
