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
        case create

        var item: ShortcutItem {
            switch self {
            case .nextField:
                return ShortcutItem(key: .tab, modifiers: [])
            case .create:
                return ShortcutItem(key: .return, modifiers: [.shift])
            }
        }
    }
}
