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

    var oldApp: NSRunningApplication?

    @objc func togglePane() {
        self.setupWindowIfNeeded()

        if self.isPanelShowed {
            self.oldApp?.activate(options: .activateIgnoringOtherApps)
            self.hidePanel()
//            NSApplication.shared.deactivate()
        } else {
            self.oldApp = NSWorkspace.shared.frontmostApplication
            NSApplication.shared.activate(ignoringOtherApps: true)
            self.window.makeKeyAndOrderFront(nil)
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
            x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
            y: mainScreen.frame.minY,
            width: self.windowFrameWidth,
            height: mainScreen.frame.height - 0
        )

        self.window = NSWindow(
            contentRect: frame,
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        self.window.backgroundColor = NSColor.clear
        self.window.contentViewController = MainPanelViewController()
        // Overlap dock, but not menu bar
        self.window.level = .statusBar - 2
    }

    func showPanel() {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        let frame = NSRect(
            x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
            y: mainScreen.frame.minY,
            width: self.windowFrameWidth,
            height: mainScreen.frame.height - 0
        )

        self.window.setFrame(frame, display: true, animate: false)

        if let view = self.window.contentView as? MainPanelView {
            view.show()
        }
        self.window.setIsVisible(true)
    }

    func hidePanel() {
        if let view = self.window.contentView as? MainPanelView {
            view.hide {
                self.window.setIsVisible(false)
            }
        }
    }
}
