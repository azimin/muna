//
//  View.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class View: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    var backgroundColor: NSColor? {
        get {
            if let cgBackgroundColor = self.layer?.backgroundColor {
                return NSColor(cgColor: cgBackgroundColor)
            } else {
                return nil
            }
        }
        set {
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
