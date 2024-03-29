//
//  MainPanelViewController+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension MainScreenViewController {
    enum Shortcut: CaseIterable, ViewShortcutProtocol {
        case preveousItem
        case nextItem
        case preveousSection
        case nextSection
        case nextTab
        case preveousTab
        case deleteItem
        case previewItem
        case complete
        case editTime
        case copyImage
        case close
        case showSmartAssistent

        var item: ShortcutItem {
            switch self {
            case .nextTab:
                return ShortcutItem(key: .rightArrow, modifiers: [])
            case .preveousTab:
                return ShortcutItem(key: .leftArrow, modifiers: [])
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
            case .editTime:
                return ShortcutItem(key: .t, modifiers: [.command])
            case .copyImage:
                return ShortcutItem(key: .c, modifiers: [.command])
            case .close:
                return ShortcutItem(key: .escape, modifiers: [])
            case .showSmartAssistent:
                return ShortcutItem(key: .s, modifiers: [.command])
            }
        }
    }
}
