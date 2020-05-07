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
    case blueSelected
    case redLight
    case separator

    var color: NSColor {
        switch self {
        case .white:
            return NSColor.white
        case .black:
            return NSColor.black
        case .white60alpha:
            return NSColor.white.withAlphaComponent(0.6)
        case .blueSelected:
            return NSColor(hex: "2C7DD3")
        case .redLight:
            return NSColor(hex: "FF8484")
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
