//
//  AppDelegate.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import MASShortcut
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    let windowManager = WindowManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.

        // Create the window and set the content view.

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        MASShortcutBinder.shared()?.breakBinding(
            withDefaultsKey: Preferences.defaultShortcutUDKey
        )
    }

    func setupUserDefaults() {
        UserDefaults.standard.register(defaults: Preferences.defaultUserDefaults)
    }

    func setupShortcuts() {
        MASShortcutBinder.shared()?.bindShortcut(
            withDefaultsKey: Preferences.defaultShortcutUDKey,
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
    }

    func setupStatusBarItem() {
        let statusBar = NSStatusBar.system

        let statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )
        statusBarItem.button?.title = "🌯"

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu

        self.statusBarItem = statusBarItem
        self.statusBarMenu = statusBarMenu

        statusBarMenu.addItem(
            withTitle: "Show items",
            action: #selector(self.togglePane),
            keyEquivalent: "o"
        )

        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(self.closeApp),
            keyEquivalent: ""
        )
    }

    var isPanelShowed = false
    var isScreenshotShowed = false

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
}
