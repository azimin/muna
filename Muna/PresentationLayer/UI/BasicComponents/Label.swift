//
//  Label.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Label: NSTextField {
    // NOT SUPPORTED YET
    private var adjustsFontSizeToFitWidth: Bool = false

    private var recommendedFont: NSFont?
    private var shouldCaptureFont: Bool = true

    var text: String {
        set {
            self.stringValue = newValue
            self.adjustIfNeeded(text: newValue)
        }
        get {
            return self.stringValue
        }
    }

    override var font: NSFont? {
        didSet {
            if self.shouldCaptureFont {
                self.recommendedFont = self.font
            }
        }
    }

    init(fontStyle: FontStyle, size: CGFloat) {
        super.init(frame: .zero)
        self.font = FontStyle.customFont(style: fontStyle, size: size)
        self.setup()
    }

    init(font: NSFont) {
        super.init(frame: .zero)
        self.font = font
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

    override func layout() {
        super.layout()
        self.adjustIfNeeded(text: self.text)
    }

    private func adjustIfNeeded(text: String) {
        guard self.adjustsFontSizeToFitWidth, let font = self.recommendedFont else {
            return
        }

        var currentFontSize = (font.fontDescriptor.fontAttributes[NSFontDescriptor.AttributeName.size] as? CGFloat) ?? 3
        self.shouldCaptureFont = false

        while true {
            if currentFontSize < 3.5 {
                break
            }

            let newFont = NSFont(
                descriptor: font.fontDescriptor,
                size: currentFontSize
            ) ?? NSFont.systemFont(ofSize: currentFontSize)

            let size = (text as NSString).size(
                withAttributes: [NSAttributedString.Key.font: newFont]
            )

            if size.width <= self.frame.width {
                break
            }

            currentFontSize -= 0.5
        }

        self.font = NSFont(
            descriptor: font.fontDescriptor,
            size: currentFontSize
        )

        self.shouldCaptureFont = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
