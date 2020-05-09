//
//  TextField.swift
//  Muna
//
//  Created by Egor Petrov on 09.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TextField: NSTextField {

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
        self.isEditable = true
        self.isBezeled = false
        self.backgroundColor = NSColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
