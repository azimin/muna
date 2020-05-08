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
    enum WindowType {
        case screenshot
        case panel
    }

    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    var mouseLocation: NSPoint { NSEvent.mouseLocation }

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
    }

    let windowFrameWidth: CGFloat = 380
    var isPanelShowed = false
    var isScreenshotShowed = false

    @objc func hidePanelIfNeeded() {
        if self.isPanelShowed {
            self.hidePanel()
            self.isPanelShowed = false
        }
    }

    @objc func hideScreenshotIfNeeded() {
        if self.isScreenshotShowed {
            self.hideScreenshotState()
            self.isScreenshotShowed = false
        }
    }

    @objc func togglePane() {
        if self.isPanelShowed {
            self.hidePanel()
        } else {
            self.setupWindow(forType: .panel)
            self.window.makeKeyAndOrderFront(nil)
            self.showPanel()
        }
        self.isPanelShowed.toggle()
    }

    func setupWindow(forType type: WindowType) {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }
        if self.window != nil {
            let frame: NSRect
            switch type {
            case .screenshot:
                frame = mainScreen.frame
                self.window.contentViewController = ScreenShotStateViewController()
            case .panel:
                frame = NSRect(
                    x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
                    y: mainScreen.frame.minY,
                    width: self.windowFrameWidth,
                    height: mainScreen.frame.height - 0
                )
                self.window.contentViewController = MainPanelViewController()
            }
            self.window.setFrame(frame, display: true)
            return
        }

        switch type {
        case .panel:
            let frame = NSRect(
                x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
                y: mainScreen.frame.minY,
                width: self.windowFrameWidth,
                height: mainScreen.frame.height - 0
            )

            self.window = Panel(
                contentRect: frame,
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            self.window.backgroundColor = NSColor.clear
            self.window.contentViewController = MainPanelViewController()
            // Overlap dock, but not menu bar
            self.window.level = .statusBar - 2
        case .screenshot:
            self.window = Panel(
                contentRect: mainScreen.frame,
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: true
            )
            self.window.backgroundColor = NSColor.white.withAlphaComponent(0.001)
            self.window.contentViewController = ScreenShotStateViewController()
            // Overlap dock, but not menu bar
            self.window.level = .statusBar - 2
        }
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

    @objc func toggleScreenshotState() {
        self.setupWindow(forType: .screenshot)

        if self.isScreenshotShowed {
            self.hideScreenshotState()
        } else {
            self.window.makeKeyAndOrderFront(nil)
            self.showScreenShotState()
        }
        self.isScreenshotShowed.toggle()
    }

    func showScreenShotState() {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        self.window.setFrame(mainScreen.frame, display: true, animate: false)

        self.window.setIsVisible(true)
    }

    func hideScreenshotState() {
        if let viewController = self.window.contentViewController as? ScreenShotStateViewController {
            viewController.hide {
                self.window.setIsVisible(false)
            }
        }
    }
}
