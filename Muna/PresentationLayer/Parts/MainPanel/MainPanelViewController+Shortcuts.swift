//
//  MainPanelViewController+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension MainPanelViewController {
    enum Shortcut: CaseIterable {
        case preveousItem
        case nextItem
        case preveousSection
        case nextSection
        case deleteItem
        case previewItem
        case complete

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
            case .complete:
                return ShortcutItem(key: .return, modifiers: [])
            }
        }
    }
}
