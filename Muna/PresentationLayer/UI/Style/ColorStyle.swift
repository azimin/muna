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

    case white
    case black
    case white60alpha
    case white60
    case gray
    case blueSelected
    case redLight
    case redDots
    case separator
    case blueSelection
    case clear

    var color: NSColor {
        switch Theme.current {
        case .dark:
            switch self {
            case .titleAccent:
                return NSColor.white
            case .title60Accent:
                return NSColor(hex: "969696")
            case .title60AccentAlpha:
                return NSColor.white.withAlphaComponent(0.6)
            case .clear:
                return NSColor.clear
            case .blueSelection:
                return NSColor(hex: "0D5AAC")
            case .white:
                return NSColor.white
            case .black:
                return NSColor.black
            case .white60alpha:
                return NSColor.white.withAlphaComponent(0.6)
            case .white60:
                return NSColor(hex: "969696")
            case .blueSelected:
                return NSColor(hex: "2C7DD3")
            case .redLight:
                return NSColor(hex: "FF8484")
            case .redDots:
                return NSColor(hex: "FF2F2F")
            case .gray:
                return NSColor(hex: "404040")
            case .separator:
                return NSColor.gray
            }
        case .light:
            switch self {
            case .titleAccent:
                return NSColor.black
            case .title60Accent:
                return NSColor(hex: "666666")
            case .title60AccentAlpha:
                return NSColor.black.withAlphaComponent(0.6)
            case .clear:
                return NSColor.clear
            case .blueSelection:
                return NSColor(hex: "0D5AAC")
            case .white:
                return NSColor.white
            case .black:
                return NSColor.black
            case .white60alpha:
                return NSColor.white.withAlphaComponent(0.6)
            case .white60:
                return NSColor(hex: "969696")
            case .blueSelected:
                return NSColor(hex: "2C7DD3")
            case .redLight:
                return NSColor(hex: "FF8484")
            case .redDots:
                return NSColor(hex: "FF2F2F")
            case .gray:
                return NSColor(hex: "404040")
            case .separator:
                return NSColor.gray
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
