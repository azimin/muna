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

    func withText(_ text: String) -> Self {
        self.title = text
        return self
    }

    func withTextColorStyle(_ colorStyle: ColorStyle) -> Self {
        self.createStyleAction(style: colorStyle) { [weak self] style in
            self?.colorStyle = style
        }
        return self
    }

    func update(imageName: String, colorStyle: ColorStyle? = nil) {
        if let colorStyle = colorStyle {
            self.image = NSImage(named: NSImage.Name(imageName))?
                .tint(color: NSColor.color(colorStyle))
        } else {
            self.image = NSImage(named: NSImage.Name(imageName))
        }
    }

    @discardableResult
    func withImageName(_ name: String, color: ColorStyle? = nil) -> Self {
        if let color = color {
            self.createStyleAction(style: color) { [weak self] style in
                self?.image = NSImage(named: NSImage.Name(name))?
                    .tint(color: NSColor.color(style))
            }
        } else {
            self.image = NSImage(named: NSImage.Name(name))
        }
        self.imagePosition = .imageOnly
        self.imageScaling = .scaleProportionallyUpOrDown
        return self
    }
}
