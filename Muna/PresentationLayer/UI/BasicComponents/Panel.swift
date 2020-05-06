//
//  Panel.swift
//  Muna
//
//  Created by Alexander on 5/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Panel: NSPanel {
    override var acceptsFirstResponder: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }

    override var canBecomeKey: Bool {
        return true
    }
}
