//
//  AppDelegate.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftUI
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.

        // Create the window and set the content view.

        self.setupUserDefaults()
        self.setupStatusBarItem()
        self.setupShortcuts()
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
        })
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
    }

    let windowFrameWidth: CGFloat = 380
    var isPanelShowed = false

    @objc func togglePane() {
        self.setupWindowIfNeeded()

        if self.isPanelShowed {
            self.hidePanel()
        } else {
            self.showPanel()
        }
        self.isPanelShowed.toggle()
    }

    func setupWindowIfNeeded() {
        if self.window != nil {
            return
        }

        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        let frame = NSRect(
            x: mainScreen.frame.width,
            y: 0,
            width: self.windowFrameWidth,
            height: mainScreen.frame.height - 0
        )

        self.window = NSWindow(
            contentRect: frame,
            styleMask: [.fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        self.window.backgroundColor = NSColor.clear
        self.window.contentView = MainPanelView()
        self.window.makeKeyAndOrderFront(nil)

        // Overlap dock, but not menu bar
        self.window.level = .statusBar - 2
    }

    func showPanel() {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        let frame = NSRect(
            x: mainScreen.frame.width - self.windowFrameWidth,
            y: 0,
            width: self.windowFrameWidth,
            height: mainScreen.frame.height - 0
        )

        self.window.setFrame(frame, display: true, animate: true)
    }

    func hidePanel() {
        guard let windowScreen = self.window.screen else {
            assertionFailure("No main screen")
            return
        }

        let frame = NSRect(
            x: windowScreen.frame.width,
            y: 0,
            width: self.windowFrameWidth,
            height: windowScreen.frame.height - 0
        )

        self.window.setFrame(frame, display: true, animate: true)
    }
}
