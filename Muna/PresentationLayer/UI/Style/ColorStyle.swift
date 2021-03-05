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
    case title80AccentAlpha
    case newTitle

    case itemSelectionColor

    case plateFullSelection

    case button

    case backgroundOverlay
    case lightOverlay
    case distructiveOverlay
    case lightForegroundOverlay
    case foregroundOverlay

    case grayBackground

    case blueSelected

    case hint
    case warning
    case warningSelected
    case redLight
    case redDots

    case separator
    case clear

    case alwaysWhite

    // MARK: Assisten

    case assitentPlateBackground
    case assitentLeftColor
    case assitentRightColor

    var color: NSColor {
        switch Theme.current {
        case .dark:
            switch self {
            case .hint:
                return NSColor(hex: "FFE37D")
            case .titleAccent:
                return NSColor.white
            case .warning, .warningSelected:
                return NSColor(hex: "EACD76")
            case .title60Accent:
                return NSColor(hex: "969696")
            case .itemSelectionColor:
                return NSColor(hex: "68B7E2")
            case .plateFullSelection:
                return NSColor.white
            case .lightOverlay:
                return NSColor.white.withAlphaComponent(0.1)
            case .distructiveOverlay:
                return NSColor(hex: "FF5555").withAlphaComponent(0.5)
            case .button:
                return NSColor(hex: "9DA4AC")
            case .title60AccentAlpha:
                return NSColor.white.withAlphaComponent(0.6)
            case .title80AccentAlpha:
                return NSColor.white.withAlphaComponent(0.8)
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
                return NSColor(hex: "FD7D7D")
            case .redDots:
                return NSColor(hex: "FF2F2F")
            case .separator:
                return NSColor(hex: "525252").withAlphaComponent(0.5)
            case .alwaysWhite:
                return NSColor.white
            case .newTitle:
                return NSColor(hex: "E3E4E4")
            case .assitentPlateBackground:
                return NSColor.white.withAlphaComponent(0.2)
            case .assitentLeftColor:
                return NSColor(hex: "FA7C7C")
            case .assitentRightColor:
                return NSColor(hex: "93B3EF")
            }
        case .light:
            switch self {
            case .hint:
                return NSColor(hex: "FFE37D")
            case .newTitle:
                return NSColor(hex: "E3E4E4")
            case .warning:
                return NSColor(hex: "AC0D0D")
            case .warningSelected:
                return NSColor(hex: "FF9F9F")
            case .titleAccent:
                return NSColor.black
            case .plateFullSelection:
                return NSColor.white
            case .itemSelectionColor:
                return NSColor(hex: "62E86E")
            case .title60Accent:
                return NSColor(hex: "666666")
            case .distructiveOverlay:
                return NSColor(hex: "FF5555").withAlphaComponent(0.5)
            case .title60AccentAlpha:
                return NSColor.black.withAlphaComponent(0.6)
            case .title80AccentAlpha:
                return NSColor.black.withAlphaComponent(0.8)
            case .button:
                return NSColor(hex: "2D2729")
            case .backgroundOverlay:
                return NSColor.black.withAlphaComponent(0.5)
            case .lightForegroundOverlay:
                return NSColor.black.withAlphaComponent(0.1)
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
            case .assitentPlateBackground:
                return NSColor.black.withAlphaComponent(0.2)
            case .assitentLeftColor:
                return NSColor(hex: "D9ECBC")
            case .assitentRightColor:
                return NSColor(hex: "EBCBF6")
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
