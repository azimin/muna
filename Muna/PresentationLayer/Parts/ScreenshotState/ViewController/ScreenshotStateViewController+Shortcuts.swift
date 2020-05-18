//
//  ScreenshotStateView+Shortcuts.swift
//  Muna
//
//  Created by Egor Petrov on 17.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension ScreenShotStateViewController {
    enum Shortcut: CaseIterable {
        case closeItem

        var item: ShortcutItem {
            switch self {
            case .closeItem:
                return ShortcutItem(key: .w, modifiers: [.command])
            }
        }
    }
}
