//
//  FontStyle.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

enum FontStyle {
    case bold
    case medium
    case heavy

    static func customFont(style: FontStyle, size: CGFloat) -> NSFont {
        switch style {
        case .bold:
            return NSFont.systemFont(ofSize: size, weight: .bold)
        case .heavy:
            return NSFont.systemFont(ofSize: size, weight: .heavy)
        case .medium:
            return NSFont.systemFont(ofSize: size, weight: .medium)
        }
    }
}
