//
//  ColorStyle.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

enum ColorStyle {
    case titleAccent
    case title60Accent
    case title60AccentAlpha
    case newTitle

    case button

    case backgroundOverlay
    case lightOverlay
    case distructiveOverlay
    case lightForegroundOverlay
    case foregroundOverlay

    case grayBackground

    case blueSelected

    case redLight
    case redDots

    case separator
    case clear

    case alwaysWhite

    var color: NSColor {
        switch Theme.current {
        case .dark:
            switch self {
            case .titleAccent:
                return NSColor.white
            case .title60Accent:
                return NSColor(hex: "969696")
            case .lightOverlay:
                return NSColor.white.withAlphaComponent(0.1)
            case .distructiveOverlay:
                return NSColor(hex: "FF5555").withAlphaComponent(0.5)
            case .button:
                return NSColor(hex: "9DA4AC")
            case .title60AccentAlpha:
                return NSColor.white.withAlphaComponent(0.6)
            case .backgroundOverlay:
                return NSColor.black.withAlphaComponent(0.5)
            case .lightForegroundOverlay:
                return NSColor.black.withAlphaComponent(0.3)
            case .foregroundOverlay:
                return NSColor.black.withAlphaComponent(0.5)
            case .grayBackground:
                return NSColor(hex: "404040")
            case .clear:
                return NSColor.clear
            case .blueSelected:
                return NSColor(hex: "2C7DD3")
            case .redLight:
                return NSColor(hex: "FF8484")
            case .redDots:
                return NSColor(hex: "FF2F2F")
            case .separator:
                return NSColor(hex: "525252").withAlphaComponent(0.5)
            case .alwaysWhite:
                return NSColor.white
            case .newTitle:
                return NSColor(hex: "E3E4E4")
            }
        case .light:
            switch self {
            case .newTitle:
                return NSColor(hex: "E3E4E4")
            case .titleAccent:
                return NSColor.black
            case .title60Accent:
                return NSColor(hex: "666666")
            case .distructiveOverlay:
                return NSColor(hex: "FF5555").withAlphaComponent(0.5)
            case .title60AccentAlpha:
                return NSColor.black.withAlphaComponent(0.6)
            case .button:
                return NSColor(hex: "2D2729")
            case .backgroundOverlay:
                return NSColor.black.withAlphaComponent(0.5)
            case .lightForegroundOverlay:
                return NSColor.white.withAlphaComponent(0.3)
            case .lightOverlay:
                return NSColor.black.withAlphaComponent(0.1)
            case .foregroundOverlay:
                return NSColor.white.withAlphaComponent(0.5)
            case .grayBackground:
                return NSColor(hex: "C6C6C6")
            case .clear:
                return NSColor.clear
            case .blueSelected:
                return NSColor(hex: "2C7DD3")
            case .redLight:
                return NSColor(hex: "FF8484")
            case .redDots:
                return NSColor(hex: "FF2F2F")
            case .separator:
                return NSColor.black.withAlphaComponent(0.13)
            case .alwaysWhite:
                return NSColor.white
            }
        }
    }
}

extension NSColor {
    static func color(_ type: ColorStyle) -> NSColor {
        return type.color
    }
}

extension CGColor {
    static func color(_ type: ColorStyle) -> CGColor {
        return NSColor.color(type).cgColor
    }
}
