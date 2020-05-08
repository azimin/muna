//
//  NSImage+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/9/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(
            origin: .zero,
            size: image.size
        )
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
}
