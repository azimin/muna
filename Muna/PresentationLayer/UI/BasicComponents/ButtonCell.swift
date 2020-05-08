//
//  ButtonCell.swift
//  Muna
//
//  Created by Alexander on 5/9/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ButtonCell: NSButtonCell {
    var highlightedAction: ((Bool) -> Void)?

    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        self.highlightedAction?(flag)
    }
}
