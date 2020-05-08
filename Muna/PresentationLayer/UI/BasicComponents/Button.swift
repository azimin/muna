//
//  Button.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Button: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBordered = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
