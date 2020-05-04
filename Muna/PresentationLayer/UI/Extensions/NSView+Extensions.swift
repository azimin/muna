//
//  NSView+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSView {
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
}
