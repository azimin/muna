//
//  ImageView.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ImageView: NSImageView {
    override var image: NSImage? {
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = .resizeAspectFill
            self.layer?.contents = newValue
            self.wantsLayer = true
            super.image = newValue
        }

        get {
            return super.image
        }
    }
}
