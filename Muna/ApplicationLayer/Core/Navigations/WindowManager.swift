//
//  WindowManager.swift
//  Muna
//
//  Created by Egor Petrov on 09.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import Foundation

enum WindowType: String {
    case panel
    case screenshot
}

class WindowManager {
    static let panelWindowFrameWidth: CGFloat = 380
    var windowFrameWidth: CGFloat {
        return WindowManager.panelWindowFrameWidth
    }

    var windows = [String: NSWindow]()

    func activateWindow(_ windowType: WindowType) {
        guard let window = self.windows[windowType.rawValue] else {
            self.setupWindow(windowType)
            return
        }
        switch windowType {
        case .panel:
            self.showPanel(in: window)
        case .screenshot:
            self.showScreenshotState(in: window)
        }
    }

    private func setupWindow(_ windowType: WindowType) {
        let window: NSWindow
        switch windowType {
        case .panel:
            window = Panel(
                contentRect: self.frameFor(.panel),
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = MainPanelViewController()
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
            // Overlap dock, but not menu bar
            window.level = .statusBar
            self.showScreenshotState(in: window)
        }

        self.windows[windowType.rawValue] = window
    }

    private func frameFor(_ windowType: WindowType) -> NSRect {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return .zero
        }

        let frame: NSRect
        switch windowType {
        case .screenshot:
            frame = mainScreen.frame
        case .panel:
            frame = NSRect(
                x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
                y: mainScreen.frame.minY,
                width: self.windowFrameWidth,
                height: mainScreen.frame.height - 0
            )
        }

        return frame
    }

    // MARK: - Window showing

    private func showPanel(in window: NSWindow) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.panel),
            display: true,
            animate: false
        )

        if let view = window.contentView as? MainPanelView {
            view.show()
        }
        window.setIsVisible(true)
    }

    private func showScreenshotState(in window: NSWindow) {
        window.makeKeyAndOrderFront(nil)

        window.setFrame(
            self.frameFor(.screenshot),
            display: true,
            animate: false
        )

        window.setIsVisible(true)
    }

    func hideWindow(_ windowType: WindowType) {
        guard let window = self.windows[windowType.rawValue] else {
            assertionFailure("Window type: \(windowType.rawValue) wasn't active")
            return
        }

        switch windowType {
        case .screenshot:
            if let viewController = window.contentViewController as? ScreenShotStateViewController {
                viewController.hide {
                    window.setIsVisible(false)
                }
            }
        case .panel:
            if let view = window.contentView as? MainPanelView {
                view.hide {
                    window.setIsVisible(false)
                }
            }
        }
    }
}
