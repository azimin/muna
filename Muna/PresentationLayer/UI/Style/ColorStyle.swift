//
//  ColorStyle.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

enum ColorStyle {
    case white
    case black
    case white60alpha
    case white60
    case gray
    case blueSelected
    case redLight
    case redDots
    case separator

    var color: NSColor {
        switch self {
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
