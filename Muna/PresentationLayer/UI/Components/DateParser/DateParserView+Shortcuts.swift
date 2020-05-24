//
//  DateParserView+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension DateParserView {
    enum Shortcuts: ViewShortcutProtocol {
        case preveousTime
        case nextTime
        case acceptTime

        var item: ShortcutItem {
            switch self {
            case .preveousTime:
                return ShortcutItem(key: .upArrow, modifiers: [])
            case .nextTime:
                return ShortcutItem(key: .downArrow, modifiers: [])
            case .acceptTime:
                return ShortcutItem(key: .return, modifiers: [])
            }
        }
    }
}
