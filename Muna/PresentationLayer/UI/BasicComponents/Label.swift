//
//  Label.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Label: NSTextField {
    init(fontStyle: FontStyle, size: CGFloat) {
        super.init(frame: .zero)
        self.font = FontStyle.customFont(style: fontStyle, size: size)
        self.setup()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    func setup() {
        self.isEditable = false
        self.isBezeled = false
        self.backgroundColor = NSColor.clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
