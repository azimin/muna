//
//  TaskCreateView+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension TaskCreateView {
    enum Shortcuts: ViewShortcutProtocol {
        case nextField
        case createViaShiftReturn
        case createViaCmdReturn

        var item: ShortcutItem {
            switch self {
            case .createViaCmdReturn:
                return ShortcutItem(key: .return, modifiers: [.command])
            case .nextField:
                return ShortcutItem(key: .tab, modifiers: [])
            case .createViaShiftReturn:
                return ShortcutItem(key: .return, modifiers: [.shift])
            }
        }
    }
}
