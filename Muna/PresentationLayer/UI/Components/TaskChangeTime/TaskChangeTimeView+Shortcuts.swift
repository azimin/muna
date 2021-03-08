//
//  TaskChangeTimeView+Shortcuts.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension TaskChangeTimeView {
    enum Shortcuts: ViewShortcutProtocol {
        case createViaShiftReturn
        case createViaCmdReturn
        case close

        var item: ShortcutItem {
            switch self {
            case .createViaCmdReturn:
                return ShortcutItem(key: .return, modifiers: [.command])
            case .createViaShiftReturn:
                return ShortcutItem(key: .return, modifiers: [.shift])
            case .close:
                return ShortcutItem(key: .w, modifiers: [.command])
            }
        }
    }
}
