//
//  MainPanelContentView+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension MainPanelContentView {
    enum Shortcuts {
        case preveousItem
        case nextItem
        case preveousSection
        case nextSection
        case deleteItem
        case previewItem

        var item: ShortcutItem {
            switch self {
            case .preveousItem:
                return ShortcutItem(key: .upArrow, modifiers: [])
            case .nextItem:
                return ShortcutItem(key: .downArrow, modifiers: [])
            case .preveousSection:
                return ShortcutItem(key: .upArrow, modifiers: [.shift])
            case .nextSection:
                return ShortcutItem(key: .downArrow, modifiers: [.shift])
            case .deleteItem:
                return ShortcutItem(key: .delete, modifiers: [])
            case .previewItem:
                return ShortcutItem(key: .space, modifiers: [])
            }
        }
    }
}
