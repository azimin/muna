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
        case create

        var item: ShortcutItem {
            switch self {
            case .create:
                return ShortcutItem(key: .return, modifiers: [.shift])
            }
        }
    }
}
