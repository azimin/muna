//
//  AppDelegate.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import MASShortcut
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
        //        print(MunaChrono().parseFromString("Do homework on next tuesday at 13:30", date: Date()))

        ServiceLocator.shared.savingService.addImage(NSImage(named: NSImage.Name("img_4"))!)
        ServiceLocator.shared.savingService.save(withItem: .init(dueDateString: "12", date: Date().addingTimeInterval(5), comment: "My comment"))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ServiceLocator.shared.itemsDatabase.saveItems()

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutScreenshotKey
        )

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutPanelKey
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
                self.toggleScreenshotState()
            }
        )

        #if DEBUG

            MASShortcutBinder.shared()?.bindShortcut(
                withDefaultsKey: Preferences.defaultShortcutDebugKey,
                toAction: {
                    self.toggleSettingsState()
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
            withTitle: "About Mena",
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

    var isPanelShowed = false
    var isScreenshotShowed = false
    var isDebugShowed = false
    var isSettingsShowed = false

    @objc func closeApp() {
        NSApplication.shared.terminate(self)
    }

    @objc func hidePanelIfNeeded() {
        if self.isPanelShowed {
            self.windowManager.hideWindow(.panel)
            self.isPanelShowed = false
        }
    }

    @objc func hideScreenshotIfNeeded() {
        if self.isScreenshotShowed {
            self.windowManager.hideWindow(.screenshot)
            self.isScreenshotShowed = false
        }
    }

    @objc func togglePane() {
        if self.isPanelShowed {
            self.windowManager.hideWindow(.panel)
        } else {
            self.windowManager.activateWindow(.panel)
            self.hideScreenshotIfNeeded()
        }
        self.isPanelShowed.toggle()
    }

    @objc func toggleScreenshotState() {
        if self.isScreenshotShowed {
            self.windowManager.hideWindow(.screenshot)
        } else {
            self.windowManager.activateWindow(.screenshot)
        }
        self.isScreenshotShowed.toggle()
    }

    @objc func toggleDebugState() {
        if self.isDebugShowed {
            self.windowManager.hideWindow(.debug)
        } else {
            self.windowManager.activateWindow(.debug)
        }
        self.isDebugShowed.toggle()
    }

    @objc func toggleSettingsState() {
        if self.isSettingsShowed {
            self.windowManager.hideWindow(.settings)
        } else {
            self.windowManager.activateWindow(.settings)
        }
        self.isSettingsShowed.toggle()
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
            actions: [completeAction, laterAction],
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
            // TODO: Implement later
            print("Show later for task")
        }

        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Showed notification")
        completionHandler([.alert, .badge, .sound])
    }
}
