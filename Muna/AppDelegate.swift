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
import SnapKit
import SwiftDate
import SwiftyChrono
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate, NSUserNotificationCenterDelegate, AssertionErrorHandlerProtocol {
    static let notificationCenter = UNUserNotificationCenter.current()

    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    lazy var windowManager = ServiceLocator.shared.windowManager

    var themeObservation: NSKeyValueObservation?

    func handleAssertion(error: NSError) {
        var properties: [String: AnalyticsValueProtocol] = [:]

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

        NSUserNotificationCenter.default.delegate = self
        if #available(OSX 10.15, *) {
            AppDelegate.notificationCenter.delegate = self
            self.registerNotificationsActions()
        }
//        TimeParserTests.test()

//        ServiceLocator.shared.itemsDatabase.generateFakeDataIfNeeded(count: 0)

        self.setupUserDefaults()
        self.setupStatusBarItem()
        self.setupShortcuts()
        self.setupUpdateItemObserver()
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hideFullscreenScreenshotIfNeeded),
            name: NSWindow.didResignKeyNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handlePassedItemsSetting),
            name: Notification.Name.updateShowPassedItemSetting,
            object: nil
        )

        Preferences.setup()

        if Preferences.isNeededToShowOnboarding || ServiceLocator.shared.betaKey.isEntered == false {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.onboarding)
        } else if Preferences.isNeededToShowAnalytics {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.analtyics)
        }

        let captureIsEnabled = ServiceLocator.shared.permissionsService.canRecordScreen
        ServiceLocator.shared.analytics.logCapturePermissions(isEnabled: captureIsEnabled)

//        ServiceLocator.shared.activeAppCheckService.starObservingApps { activeApp in
//            let nowTime = Date().timeIntervalSince1970
//            let isNeededToPlayAnimation: Bool
//            switch activeApp {
//            case .notes:
//                let isBigGap = nowTime - Preferences.hintShowedForNotesTimeInterval > PresentationLayerConstants.oneHourInSeconds * 2
//                isNeededToPlayAnimation = Preferences.splashOnNotes && isBigGap
//                if Preferences.splashOnNotes {
//                    Preferences.hintShowedForNotesTimeInterval = Date().timeIntervalSince1970
//                }
//            case .reminders:
//                let isBigGap = nowTime - Preferences.hintShowedForRemindersTimeInterval > PresentationLayerConstants.oneMinuteInSeconds * 30
//                isNeededToPlayAnimation = Preferences.splashOnReminders && isBigGap
//                if Preferences.splashOnReminders {
//                    Preferences.hintShowedForRemindersTimeInterval = Date().timeIntervalSince1970
//                }
//            case .things:
//                let isBigGap = nowTime - Preferences.hintShowedForRemindersTimeInterval > PresentationLayerConstants.oneMinuteInSeconds * 30
//                isNeededToPlayAnimation = Preferences.splashOnThings && isBigGap
//                if Preferences.splashOnThings {
//                    Preferences.hintShowedForRemindersTimeInterval = Date().timeIntervalSince1970
//                }
//            }
//
//            let database = ServiceLocator.shared.itemsDatabase
//            let numberOfComplitedItems = database.fetchNumberOfCompletedItems()
//            let numberOfCreatedItems = database.fetchItems(filter: .uncompleted).filter { $0.dueDate != nil}.count
//            let theWholeNumberOfItems = numberOfComplitedItems + numberOfCreatedItems
//
//            let isBigGapAfterStart = nowTime - Preferences.lastActiveTimeInterval > PresentationLayerConstants.oneHourInSeconds
//
//            if isNeededToPlayAnimation, isBigGapAfterStart, theWholeNumberOfItems < 15 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                }
//            }
//        }
        
        
        if ServiceLocator.shared.itemsDatabase.fetchItems(filter: .all).count < 3, Preferences.isNeededToShowOnboarding == false {
        }

        self.showHintIfPossible()
        ServiceLocator.shared.inAppPurchaseManager.loadProducts()
        ServiceLocator.shared.inAppPurchaseManager.completeTransaction()
        ServiceLocator.shared.inAppPurchaseManager.validateSubscription(nil)

        self.refreshNumberOfPassedItems(force: true)
    }

    func scheduleMissingNotifications() {
        for item in ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted) {
            if let date = item.dueDate, date.isInPast {
                self.pingNotificationSetup(itemId: item.id, onlyIfMissing: true)
            }
        }
    }
    
    func showHintIfPossible() {
        let numberOfItems = ServiceLocator.shared.itemsDatabase.fetchItems(filter: .all).count
        
        var dockIsVisible = false
        
        if let mainScreen = NSScreen.main {
            dockIsVisible = mainScreen.visibleFrame.height < mainScreen.frame.height
        }

        guard numberOfItems < 3, Preferences.isNeededToShowOnboarding == false, dockIsVisible else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ServiceLocator.shared.windowManager.showHintPopover(sender: self.statusBarItem.button!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ServiceLocator.shared.itemsDatabase.saveItems()

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutVisualTaskKey
        )

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutPanelKey
        )

        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutTextTaskKey
        )
    }

    func setupUserDefaults() {
        UserDefaults.standard.register(defaults: Preferences.defaultUserDefaults)
    }

    private var itemUpdateObservable: ObserverTokenProtocol?

    func setupUpdateItemObserver() {
        self.itemUpdateObservable = ServiceLocator.shared.itemsDatabase.itemUpdated.observe(self) { (_, _) in
            self.refreshNumberOfPassedItems(force: false)
        }

        let timer = Timer(timeInterval: 10, repeats: true) { (_) in
            self.refreshNumberOfPassedItems(force: false)
        }
        RunLoop.main.add(timer, forMode: .common)

        self.themeObservation = NSApp.observe(\.effectiveAppearance) { (_, _) in
            OperationQueue.main.addOperation {
                self.refreshNumberOfPassedItems(force: true)
            }
        }
    }

    func setupShortcuts() {
        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutPanelKey,
            toAction: {
                Preferences.lastActiveTimeInterval = Date().timeIntervalSince1970
                self.togglePane()
            }
        )

        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutVisualTaskKey,
            toAction: {
                Preferences.lastActiveTimeInterval = Date().timeIntervalSince1970
                self.hideScreenshotIfNeeded()
                self.hideFullscreenScreenshotIfNeeded()
                self.toggleScreenshotState()
            }
        )

        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutTextTaskKey,
            toAction: {
                Preferences.lastActiveTimeInterval = Date().timeIntervalSince1970
                self.hideScreenshotIfNeeded()
                self.hideFullscreenScreenshotIfNeeded()
                self.toogleFullscreenScreenshotState()
            }
        )

        #if DEBUG

            MASShortcutBinder.shared()?.bindShortcut(
                withDefaultsKey: Preferences.defaultShortcutDebugKey,
                toAction: { [unowned self] in
                    self.windowManager.activateWindowIfNeeded(.onboarding)
//                    ServiceLocator.shared.inAppPurchaseManager.buyProduct(.monthly)
//                    ServiceLocator.shared.inAppPurchaseManager.loadProducts()
                }
            )

        #endif
    }

    let iconView = AnimatedBarIconView()

    func animateView() {
        self.iconView.animateView()
    }

    private var statusBarNumber = 0

    func updateStatusBar(number: Int, force: Bool) {
        guard let statusBarItem = self.statusBarItem else {
            return
        }

        guard Preferences.isNeededToShowPassedItems else {
            self.statusBarNumber = 0
            statusBarItem.length = NSStatusItem.squareLength
            statusBarItem.button?.attributedTitle = NSAttributedString()
            return
        }

        guard number > 0 else {
            self.statusBarNumber = number
            statusBarItem.length = NSStatusItem.squareLength
            statusBarItem.button?.attributedTitle = NSAttributedString()
            return
        }

        if force == false, self.statusBarNumber == number {
            return
        }

        self.statusBarNumber = number

        let string = "\u{2009}(\(number))"
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: FontStyle.customFont(style: .regular, size: 14),
                .foregroundColor: ColorStyle.titleAccent.color,
            ]
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: ColorStyle.redStatusBarWarning.color,
            range: NSRange(location: 2, length: string.count - 3)
        )

        let titleWidth = attributedString.boundingRect(with: .init(width: 1000, height: 30), options: .usesLineFragmentOrigin).width

        statusBarItem.length = NSStatusItem.squareLength + ceil(titleWidth) + 22
        statusBarItem.button?.attributedTitle = attributedString
    }

    func refreshNumberOfPassedItems(force: Bool) {
        let number = ServiceLocator.shared.itemsDatabase.numberOfPassedItem
        self.updateStatusBar(number: number, force: force)
    }

    func setupStatusBarItem() {
        let statusBar = NSStatusBar.system

        let statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )

        let image = NSImage(named: NSImage.Name("icon_menu"))
        image?.isTemplate = true

        statusBarItem.button?.image = image
        statusBarItem.button?.imagePosition = .imageLeft

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu

        self.statusBarItem = statusBarItem
        self.statusBarMenu = statusBarMenu

        let makeFullScreenshotItem = NSMenuItem(
            title: "Capture a written note",
            action: #selector(self.toogleFullscreenScreenshotState),
            keyEquivalent: "1"
        )
        makeFullScreenshotItem.keyEquivalentModifierMask = [.shift, .command]
        statusBarMenu.addItem(makeFullScreenshotItem)

        let makeSelectedAreaScreenshot = NSMenuItem(
            title: "Capture a visual note",
            action: #selector(self.toggleScreenshotState),
            keyEquivalent: "2"
        )
        makeSelectedAreaScreenshot.keyEquivalentModifierMask = [.shift, .command]
        statusBarMenu.addItem(makeSelectedAreaScreenshot)

        let item = NSMenuItem(
            title: "Show Reminders",
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
            action: #selector(self.toggleAboutSettingsState),
            keyEquivalent: ""
        )

        statusBarMenu.addItem(
            withTitle: "Show Tutorial",
            action: #selector(self.showOnboarding),
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

    @objc
    func handlePassedItemsSetting() {
        self.refreshNumberOfPassedItems(force: true)
    }

    @objc
    func forceRefreshStatusBar() {
        self.refreshNumberOfPassedItems(force: true)
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
        self.windowManager.hideWindowIfNeeded(.textTaskCreation)
    }

    @objc func togglePane() {
        self.windowManager.toggleWindow(.panel(selectedItem: nil))
    }

    @objc func showOnboarding() {
        self.windowManager.activateWindowIfNeeded(.onboarding)
    }

    @objc func toggleScreenshotState() {
        if ServiceLocator.shared.permissionsService.checkPermissions() {
            self.windowManager.toggleWindow(.screenshot)
        }
    }

    @objc func toogleFullscreenScreenshotState() {
        self.windowManager.toggleWindow(.textTaskCreation)
    }

    @objc func toggleDebugState() {
        self.windowManager.toggleWindow(.debug)
    }

    @objc func toggleSettingsState() {
        self.windowManager.activateWindowIfNeeded(.settings(item: .general))
    }

    @objc func toggleAboutSettingsState() {
        self.windowManager.activateWindowIfNeeded(.settings(item: .about))
    }

    // MARK: - Notifications

    func registerNotificationsActions() {
        let laterAction = UNNotificationAction(
            identifier: NotificationAction.later.rawValue,
            title: "Preview",
            options: .foreground
        )

        let category = UNNotificationCategory(
            identifier: "item",
            actions: [laterAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        AppDelegate.notificationCenter.setNotificationCategories([category])
    }

    // MARK: - User Notifications

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        ServiceLocator.shared.notifications.cleanUpNotifications()
        completionHandler([.alert, .sound])
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
            self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
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
            self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
            if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId) {
                self.windowManager.toggleWindow(.remindLater(item: item))
            } else {
                appAssertionFailure("No item by id")
            }
        case .dismiss:
            self.pingNotificationSetup(itemId: itemId, onlyIfMissing: false)
            completionHandler()
        }
    }

    // MARK: - Old Notifications

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

    // MARK: - Ping

    func pingNotificationSetup(itemId: String, onlyIfMissing: Bool) {
        if let item = ServiceLocator.shared.itemsDatabase.item(by: itemId),
            let dueDate = item.dueDate
        {
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
