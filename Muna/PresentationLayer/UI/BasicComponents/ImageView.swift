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
        self.wantsLayer = true
        self.image = NSImage(named: NSImage.Name(name))
    }

    init(aspectRation: CALayerContentsGravity = .resizeAspectFill) {
        self.aspectRation = aspectRation
        super.init(frame: .zero)
        self.wantsLayer = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var image: NSImage? {
        get {
            return super.image
        }
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = self.aspectRation
            self.layer?.contents = newValue
            super.image = newValue
        }
    }
}
