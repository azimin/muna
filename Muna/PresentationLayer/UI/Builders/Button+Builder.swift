//
//  Button+Builder.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension Button {
    func withImage(_ image: NSImage) -> Self {
        self.image = image
        self.imagePosition = .imageOnly
        self.imageScaling = .scaleProportionallyUpOrDown
        return self
    }

    func withImageName(_ name: String) -> Self {
        self.image = NSImage(named: NSImage.Name(name))
        self.imagePosition = .imageOnly
        self.imageScaling = .scaleProportionallyUpOrDown
        return self
    }
}
