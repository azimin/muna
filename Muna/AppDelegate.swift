//
//  AppDelegate.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.

        // Create the window and set the content view.

        self.setupStatusBarItem()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showItems()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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
            action: #selector(self.showItems),
            keyEquivalent: "o"
        )
    }

    @objc func showItems() {
//        if let window = self.window, window.isVisible {
//            self.window = nil
//            window.close()
//            return
//        }

        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        let contentView = ContentView(
            topPadding: self.statusBarMenu.size.height
        )

        let width: CGFloat = 380

        let frame = NSRect(
            x: mainScreen.frame.width - width,
            y: 0,
            width: width,
            height: mainScreen.frame.height - 0
        )

        window = NSWindow(
            contentRect: frame,
            styleMask: [.fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.setFrame(frame, display: true, animate: true)
        window.contentView = MainPanelView()
        window.makeKeyAndOrderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(5)
            print(self.window)
        }

        // Overlap dock, but not menu bar
//        window.level = .statusBar - 2
    }
}
