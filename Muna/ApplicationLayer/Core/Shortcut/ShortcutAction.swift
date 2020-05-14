//
//  ShortcutAction.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ShortcutAction {
    var item: ShortcutItem
    var action: VoidBlock?

    init(item: ShortcutItem, action: VoidBlock?) {
        self.item = item
        self.action = action
    }
}
