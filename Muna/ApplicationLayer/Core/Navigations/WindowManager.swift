//
//  WindowManager.swift
//  Muna
//
//  Created by Egor Petrov on 09.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import Foundation

enum WindowType: Equatable, Hashable {
    case panel
    case screenshot
    case fullScreenshot
    case debug
    case settings
    case remindLater(item: ItemModel)

    var rawValue: String {
        switch self {
        case .panel:
            return "panel"
        case .screenshot:
            return "panel"
        case .fullScreenshot:
            return "fullScreenshot"
        case .debug:
            return "debug"
        case .settings:
            return "settings"
        case let .remindLater(item):
            return "remindLater_\(item.id)"
        }
    }

    static func == (lhs: WindowType, rhs: WindowType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    func hash(into hasher: inout Hasher) {
        self.rawValue.hash(into: &hasher)
    }
}

class WindowManager {
    static let panelWindowFrameWidth: CGFloat = 380
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
        case .settings:
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
            case .settings:
                NSApp.activate(ignoringOtherApps: true)
                self.windows[windowType]?.makeKeyAndOrderFront(nil)
            case .debug, .panel, .screenshot, .fullScreenshot, .remindLater:
                break
            }
            return
        }

        guard let window = self.windows[windowType], windowType != .settings else {
            self.setupWindow(windowType)
            return
        }

        switch windowType {
        case .debug:
            self.showDebug(in: window)
        case .panel:
            self.showPanel(in: window)
        case .screenshot:
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: false)
        case .fullScreenshot:
            self.showScreenshotState(in: window, isNeededToMakeFullscreenScreenshot: true)
        case .settings:
            self.showSettings(in: window)
        case .remindLater:
            self.showRemindLater(in: window)
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
        case .panel:
            window = Panel(
                contentRect: self.frameFor(.panel),
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = MainScreenViewController()
            window.hasShadow = false
            // Overlap dock, but not menu bar
            window.level = .statusBar - 2
            self.showPanel(in: window)
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
        case .settings:
            window = NSWindow(
                contentRect: self.frameFor(.settings),
                styleMask: [.closable, .titled],
                backing: .buffered,
                defer: true
            )
            window.contentViewController = SettingsViewController()
            self.showSettings(in: window)
        }

        self.windows[windowType] = window
        self.changeWindowState(windowType, state: true)
    }

    private func frameFor(_ windowType: WindowType) -> NSRect {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
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

    private func showRemindLater(in window: NSWindow) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.panel),
            display: true,
            animate: false
        )

        if let viewController = window.contentViewController as? MainScreenViewController {
            viewController.show()
        }
        window.setIsVisible(true)
    }

    private func showPanel(in window: NSWindow) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.panel),
            display: true,
            animate: false
        )

        if let viewController = window.contentViewController as? MainScreenViewController {
            viewController.show()
        }
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
            assertionFailure("Window type: \(windowType.rawValue) wasn't active")
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
                self.windows[key] = nil
                self.windowVisibleStatus[key] = true
            }
        }
    }
}
