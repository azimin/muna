//
//  ImageView.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ImageView: NSImageView {
    var aspectRation: CALayerContentsGravity = .resizeAspectFill

    init(name: String, aspectRation: CALayerContentsGravity = .resizeAspectFill) {
        self.aspectRation = aspectRation
        super.init(frame: .zero)
        self.image = NSImage(named: NSImage.Name(name))
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var image: NSImage? {
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = self.aspectRation
            self.layer?.contents = newValue
            self.wantsLayer = true
            super.image = newValue
        }

        get {
            return super.image
        }
    }
}
