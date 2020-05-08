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
    var windows = [String: NSWindow]()

    func activateWindow(_ windowType: WindowType) {
        guard let window = self.windows[windowType.rawValue] else {
            self.setupWindow(windowType)
            return
        }
        window.setIsVisible(true)
    }

    let windowFrameWidth: CGFloat = 380

    private func setupWindow(_ windowType: WindowType) {
        guard let mainScreen = NSScreen.main else {
            assertionFailure("No main screen")
            return
        }

        let window: NSWindow
        switch windowType {
        case .panel:
            let frame = NSRect(
                x: mainScreen.frame.minX + mainScreen.frame.width - self.windowFrameWidth,
                y: mainScreen.frame.minY,
                width: self.windowFrameWidth,
                height: mainScreen.frame.height - 0
            )

            window = Panel(
                contentRect: frame,
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            window.backgroundColor = NSColor.clear
            window.contentViewController = MainPanelViewController()
            // Overlap dock, but not menu bar
            window.level = .statusBar - 2
        case .screenshot:
            window = Panel(
                contentRect: mainScreen.frame,
                styleMask: [.nonactivatingPanel],
                backing: .buffered,
                defer: true
            )
            window.backgroundColor = NSColor.white.withAlphaComponent(0.001)
            window.contentViewController = ScreenShotStateViewController()
            // Overlap dock, but not menu bar
            window.level = .statusBar
        }

        self.windows[windowType.rawValue] = window
        window.setIsVisible(true)
    }

    private func hideWindow(_ windowType: WindowType) {
        self.windows[windowType.rawValue]?.setIsVisible(false)
    }
}
