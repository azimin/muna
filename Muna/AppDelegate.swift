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
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    let windowManager = WindowManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
            if granted {
                print("Approval granted to send notifications")
            } else if let error = error {
                print(error)
            }
        }
        UNUserNotificationCenter.current().delegate = self

//        TimeParserTests.test()

        self.registerNotificationsActions()
        self.setupUserDefaults()
        self.setupStatusBarItem()
        self.setupShortcuts()

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

        ServiceLocator.shared.itemsDatabase.generateFakeDataIfNeeded(count: 6)

//        TimeParserTests.test()

        let currentTime = TimeZone.current.secondsFromGMT()
        let date = Date() + currentTime.seconds
//        print("In 2h")
//        print("\(MunaChrono().parseFromString("In 2h", date: date))\n")
//
//        print("In 50 mins")
//        print("\(MunaChrono().parseFromString("In 50 mins", date: date))\n")
//
//        print("Tomorrow")
//        print("\(MunaChrono().parseFromString("Tomorrow", date: date))\n")
//
//        print("tomorrow")
//        print("\(MunaChrono().parseFromString("tomorrow", date: date))\n")
//
//        print("Yesterday at 5pm")
//        print("\(MunaChrono().parseFromString("Yesterday at 5pm", date: date))\n")
//
//        print("5.30")
//        print("\(MunaChrono().parseFromString("5.30", date: date))\n")
//
//        print("5.30am")
//        print("\(MunaChrono().parseFromString("5.30am", date: date))\n")
//
//        print("In 1.5h")
//        print("\(MunaChrono().parseFromString("In 1.5h", date: date))\n")
//
//        print("In 4h")
//        print("\(MunaChrono().parseFromString("In 4h", date: date))\n")
//        print("In 1h")
//        print("\(MunaChrono().parseFromString("In 1h", date: date))\n")
//
//        print("In 1.35h")
//        print("\(MunaChrono().parseFromString("In 1.35h", date: date))\n")
//
//        print("On sun")
//        print("\(MunaChrono().parseFromString("On sun", date: date)))\n")
//
//        print("Wed 8:30 pm")
//        print("\(MunaChrono().parseFromString("Wed 8:30 pm", date: date)))\n")
//
//        print("Next Friday 8 30 pm")
//        print("\(MunaChrono().parseFromString("Next Friday 8 30 pm", date: date)))\n")
//
//        print("On weekends")
//        print("\(MunaChrono().parseFromString("On weekends", date: date)))\n")
//
//        print("Remind on weekends at 20.00")
//        print("\(MunaChrono().parseFromString("Remind on weekends at 20.00", date: date)))\n")
//
//        print("In 4h")
//        print("\(MunaChrono().parseFromString("In 4h", date: date)))\n")
//        print("20 may")
//        print("\(MunaChrono().parseFromString("20 may", date: date)))\n")
//
//        print("may 21st")
//        print("\(MunaChrono().parseFromString("may 21st", date: date)))\n")
//
//        print("Next month")
//        print("\(MunaChrono().parseFromString("Next month", date: date)))\n")
//
//        print("20 July")
//        print("\(MunaChrono().parseFromString("20 July", date: date)))\n")

        print("20 July at 13:00")
        print("\(MunaChrono().parseFromString("20 July at 13:00", date: date)))\n")

//        print("20")
//        print("\(MunaChrono().parseFromString("20", date: date)))\n")

//        Tomorrow evening
//        At evening 7.30 pm
//        In 3 days in the morning
//        Thu 7 pm (if today monday)
//        Thu 7 pm (if today wed)
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
                    self.toggleDebugState()
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

        let item = NSMenuItem(
            title: "Show items",
            action: #selector(self.togglePane),
            keyEquivalent: "t"
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
        self.windowManager.hideWindowIfNeeded(.panel)
    }

    @objc func hideScreenshotIfNeeded() {
        self.windowManager.hideWindowIfNeeded(.screenshot)
    }

    @objc func hideFullscreenScreenshotIfNeeded() {
        self.windowManager.hideWindowIfNeeded(.fullScreenshot)
    }

    @objc func togglePane() {
        self.windowManager.toggleWindow(.remindLater(item: ServiceLocator.shared.itemsDatabase.fetchItems(filter: .all).first!))
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
        self.windowManager.toggleWindow(.settings)
    }

    // MARK: - User Notifications

    func registerNotificationsActions() {
        let completeAction = UNNotificationAction(
            identifier: NotificationAction.complete.rawValue,
            title: "Complete",
            options: .destructive
        )

        let laterAction = UNNotificationAction(
            identifier: NotificationAction.later.rawValue,
            title: "Later",
            options: .authenticationRequired
        )

        let category = UNNotificationCategory(
            identifier: "item",
            actions: [laterAction, completeAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        guard let action = NotificationAction(rawValue: response.actionIdentifier) else {
            completionHandler()
            return
        }

        guard let itemId = response.notification.request.content.userInfo["item_id"] as? String else {
            completionHandler()
            return
        }

        switch action {
        case .complete:
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                item.isComplited = true
                ServiceLocator.shared.itemsDatabase.saveItems()
            } else {
                assertionFailure("No item by id")
            }
        case .later:
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                ServiceLocator.shared.notifications.sheduleNotification(item: item, offset: 10 * 60)
                self.windowManager.toggleWindow(.remindLater(item: item))
            } else {
                assertionFailure("No item by id")
            }
        }

        completionHandler()
    }
}
