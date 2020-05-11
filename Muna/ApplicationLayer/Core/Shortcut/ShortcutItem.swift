//
//  ShortcutItem.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import MASShortcut

class ShortcutItem {
    let key: Key
    let modifiers: NSEvent.ModifierFlags

    init(key: Key, modifiers: NSEvent.ModifierFlags) {
        self.key = key
        self.modifiers = modifiers
    }

    var masShortcut: MASShortcut? {
        return MASShortcut(
            keyCode: Int(self.key.carbonKeyCode),
            modifierFlags: self.modifiers
        )
    }
}
