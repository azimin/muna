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

    var modifierFlags: [NSEvent.ModifierFlags] {
        return self.modifiers.splitToSingleFlags(discardNotImportant: false)
    }

    func validateWith(event: NSEvent) -> Bool {
        let eventFlags = event.modifierFlags.splitToSingleFlags(discardNotImportant: true)
        let keyFlag = self.modifiers.splitToSingleFlags(discardNotImportant: true)
        return event.keyCode == self.key.carbonKeyCode
            && eventFlags == keyFlag
    }
}

extension NSEvent.ModifierFlags {
    func splitToSingleFlags(discardNotImportant: Bool) -> [NSEvent.ModifierFlags] {
        var result: [NSEvent.ModifierFlags] = []

        if self.contains(.capsLock) {
            result.append(.capsLock)
        }

        if self.contains(.shift) {
            result.append(.shift)
        }

        if self.contains(.option) {
            result.append(.option)
        }

        if self.contains(.command) {
            result.append(.command)
        }

        if self.contains(.numericPad), discardNotImportant == false {
            result.append(.numericPad)
        }

        if self.contains(.help), discardNotImportant == false {
            result.append(.help)
        }

        if self.contains(.function), discardNotImportant == false {
            result.append(.function)
        }

        if self.contains(.deviceIndependentFlagsMask), discardNotImportant == false {
            result.append(.deviceIndependentFlagsMask)
        }

        return result
    }
}
