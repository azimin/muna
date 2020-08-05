//
//  WindowManager.swift
//  Muna
//
//  Created by Egor Petrov on 09.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import Foundation

protocol WindowManagerProtocol {
    func toggleWindow(_ windowType: WindowType)
    func activateWindowIfNeeded(_ windowType: WindowType)
    func hideWindowIfNeeded(_ windowType: WindowType)
}

class WindowManager: WindowManagerProtocol {
    static let panelWindowFrameWidth: CGFloat = 400
    var windowFrameWidth: CGFloat {
        return WindowManager.panelWindowFrameWidth
    }

    private var windows = [WindowType: NSWindow]()
    private var windowVisibleStatus: [WindowType: Bool] = [:]

    init() {
        self.setup()
    }

    private func windowState(_ windowType: WindowType) -> Bool {
        let status: Bool
        switch windowType {
        case .settings, .onboarding:
            status = self.windows[windowType]?.isVisible ?? false
        case .debug, .panel, .screenshot, .fullScreenshot, .remindLater:
            status = self.windowVisibleStatus[windowType] ?? false
        }

        return status
    }

    private func changeWindowState(_ windowType: WindowType, state: Bool) {
        self.windowVisibleStatus[windowType] = state
    }

    func toggleWindow(_ windowType: WindowType) {
        let status: Bool = self.windowState(windowType)

        if status == false {
            self.activateWindowIfNeeded(windowType)
        } else {
            self.hideWindowIfNeeded(windowType)
        }
    }

    func activateWindowIfNeeded(_ windowType: WindowType) {
        guard self.windowState(windowType) == false else {
            switch windowType {
            case .settings, .onboarding:
                NSApp.activate(ignoringOtherApps: true)
                self.windows[windowType]?.makeKeyAndOrderFront(nil)
            case .debug, .panel, .screenshot, .fullScreenshot, .remindLater:
                break
            }
            return
        }

        ServiceLocator.shared.analytics.logEvent(name: "Show Window", properties: [
            "type": windowType.analytics,
        ])

        guard let window = self.windows[windowType], windowType != .settings else {
            self.setupWindow(windowType)
            return
        }

        switch windowType {
        case .debug:
            self.showDebug(in: window)
        case let .panel(selectedItem):
            self.showPanel(in: window, selectedItem: selectedItem)
        case .screenshot:
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: false)
        case .fullScreenshot:
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: true)
        case .onboarding:
            self.showOnboarding(in: window)
        case .settings:
            self.showSettings(in: window)
        case let .remindLater(item):
            self.showRemindLater(in: window, item: item)
        }

        self.changeWindowState(windowType, state: true)
    }

    private func setupWindow(_ windowType: WindowType) {
        let window: NSWindow
        switch windowType {
        case let .remindLater(item):
            window = Panel(
                contentRect: self.frameFor(windowType),
                styleMask: [.nonactivatingPanel, .borderless],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = RemindLaterViewController(itemModel: item)
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: false)
        case .debug:
            window = Panel(
                contentRect: self.frameFor(.debug),
                styleMask: [.nonactivatingPanel, .borderless],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = DebugViewController()
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: false)
        case let .panel(selectedItem):
            window = Panel(
                contentRect: self.frameFor(windowType),
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = MainScreenViewController()
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar - 2
            self.showPanel(in: window, selectedItem: selectedItem)
        case .screenshot:
            window = Panel(
                contentRect: self.frameFor(.screenshot),
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: true
            )
            window.backgroundColor = NSColor.white.withAlphaComponent(0.001)
            window.contentViewController = ScreenShotStateViewController()
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: false)
        case .fullScreenshot:
            window = Panel(
                contentRect: self.frameFor(.screenshot),
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: true
            )
            window.backgroundColor = NSColor.white.withAlphaComponent(0.001)
            window.contentViewController = ScreenShotStateViewController()
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: true)
        case .onboarding:
            window = NSWindow(
                contentRect: self.frameFor(.onboarding),
                styleMask: [.closable, .titled],
                backing: .buffered,
                defer: true
            )
            window.titlebarAppearsTransparent = true
            window.isReleasedWhenClosed = false
            window.contentViewController = OnboardingViewController()
            self.showSettings(in: window)
        case .settings:
            window = NSWindow(
                contentRect: self.frameFor(.settings),
                styleMask: [.closable, .titled],
                backing: .buffered,
                defer: true
            )
            window.isReleasedWhenClosed = false
            window.contentViewController = SettingsViewController()
            self.showSettings(in: window)
        }

        self.windows[windowType] = window
        self.changeWindowState(windowType, state: true)
    }

    private func frameFor(_ windowType: WindowType) -> NSRect {
        guard let mainScreen = NSScreen.main else {
            appAssertionFailure("No main screen")
            return .zero
        }

        let frame: NSRect
        switch windowType {
        case .debug:
            frame = mainScreen.frame
        case .screenshot, .fullScreenshot:
            frame = mainScreen.frame
        case .panel:
            frame = mainScreen.frame
        case .remindLater:
            frame = mainScreen.frame
        case .onboarding:
            frame = NSRect(x: 0, y: 0, width: 640, height: 640)
        case .settings:
            frame = NSRect(x: 0, y: 0, width: 300, height: 400)
        }

        return frame
    }

    // MARK: - Window showing

    private func showDebug(in window: NSWindow) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.debug),
            display: true,
            animate: false
        )

        window.setIsVisible(true)
    }

    private func showRemindLater(in window: NSWindow, item: ItemModel) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.remindLater(item: item)),
            display: true,
            animate: false
        )

        if let viewController = window.contentViewController as? MainScreenViewController {
            viewController.show()
        }
        window.setIsVisible(true)
    }

    private func showPanel(in window: NSWindow, selectedItem: ItemModel?) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.panel(selectedItem: selectedItem)),
            display: true,
            animate: false
        )

        if let viewController = window.contentViewController as? MainScreenViewController {
            viewController.show(selectedItem: selectedItem)
        }
        window.setIsVisible(true)
    }

    private func showOnboarding(in window: NSWindow) {
        NSApp.activate(ignoringOtherApps: true)
        window.setIsVisible(true)
    }

    private func showSettings(in window: NSWindow) {
        NSApp.activate(ignoringOtherApps: true)
        window.setIsVisible(true)
    }

    private func showScreenshotState(in window: NSWindow, isNeededToMakeFullscreenScreenshot: Bool) {
        window.makeKeyAndOrderFront(nil)

        if let viewController = window.contentViewController as? ScreenShotStateViewController {
            viewController.windowId = CGWindowID(window.windowNumber)
        }

        window.setFrame(
            self.frameFor(.screenshot),
            display: true,
            animate: false
        )

        if let viewController = window.contentViewController as? ScreenShotStateViewController {
            viewController.show(isFullscreenScreenshotState: isNeededToMakeFullscreenScreenshot)
            if isNeededToMakeFullscreenScreenshot {
                viewController.makeScreenshot()
                viewController.isFullscreenScreenshotState = true
            }
        }

        window.setIsVisible(true)
    }

    func hideWindowIfNeeded(_ windowType: WindowType) {
        guard self.windowState(windowType) == true else {
            return
        }

        guard let window = self.windows[windowType] else {
            appAssertionFailure("Window type: \(windowType.rawValue) wasn't active")
            return
        }

        switch windowType {
        case .debug:
            window.setIsVisible(false)
        case .screenshot, .fullScreenshot:
            if let viewController = window.contentViewController as? ScreenShotStateViewController {
                viewController.hide {
                    window.setIsVisible(false)
                }
            }
            window.close()
            self.windows[windowType] = nil
        case .panel:
            if let viewController = window.contentViewController as? MainScreenViewController {
                viewController.hide {
                    window.setIsVisible(false)
                }
            }
        case .remindLater:
            window.setIsVisible(false)
            self.windows[windowType] = nil
        case .settings:
            window.setIsVisible(false)
        case .onboarding:
            window.setIsVisible(false)
        }

        self.changeWindowState(windowType, state: false)
    }

    private func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.windowClosed),
            name: NSWindow.willCloseNotification,
            object: nil
        )
    }

    @objc
    func windowClosed(notification: NSNotification) {
        for (key, value) in self.windows {
            if let windowToClose = notification.object as? NSWindow,
                value == windowToClose {
                self.windowVisibleStatus[key] = false
                self.windows[key] = nil
            }
        }
    }
}
