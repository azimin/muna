//
//  NSScreen+Transform.swift
//  Muna
//
//  Created by Alexander on 10/1/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSScreen {
    static var primaryScreen: NSScreen? {
        return NSScreen.screens.first
    }

    func convertRectToPrimaryScreen(rect: NSRect) -> NSRect {
        if self == NSScreen.primaryScreen {
            return rect
        }

        guard let primaryScreen = NSScreen.primaryScreen else {
            appAssertionFailure("No screen")
            return rect
        }

        var rect = rect
        rect.origin.y += (primaryScreen.frame.height - frame.minY - frame.height)

        return rect
    }
}
