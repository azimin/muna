//
//  TaskCreateView+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension TaskCreateView {
    enum Shortcuts {
        case preveousTime
        case nextTime
        case acceptTime
        case nextField
        case create

        var item: ShortcutItem {
            switch self {
            case .preveousTime:
                return ShortcutItem(key: .upArrow, modifiers: [])
            case .nextTime:
                return ShortcutItem(key: .downArrow, modifiers: [])
            case .nextField:
                return ShortcutItem(key: .tab, modifiers: [])
            case .create:
                return ShortcutItem(key: .return, modifiers: [.command])
            case .acceptTime:
                return ShortcutItem(key: .return, modifiers: [])
            }
        }
    }
}
