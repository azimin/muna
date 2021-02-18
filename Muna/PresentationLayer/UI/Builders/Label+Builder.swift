//
//  Label+Builder.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension Label {
    func withTextColorStyle(_ colorStyle: ColorStyle) -> Self {
        self.createStyleAction(style: colorStyle) { [weak self] style in
            self?.textColor = NSColor.color(style)
        }
        return self
    }

    func withText(_ text: String) -> Self {
        self.stringValue = text
        return self
    }

    func withAligment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    func withLimitedNumberOfLines(_ numberOfLines: Int) -> Self {
        self.maximumNumberOfLines = numberOfLines
        return self
    }
}
