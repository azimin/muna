//
//  NSStackView+Init.swift
//  Muna
//
//  Created by Alexander on 5/20/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSStackView {
    convenience init(
        orientation: NSUserInterfaceLayoutOrientation,
        alignment: NSLayoutConstraint.Attribute = .leading,
        distribution: NSStackView.Distribution = .fill
    ) {
        self.init()

        self.orientation = orientation
        self.alignment = alignment
        self.distribution = distribution
    }
}
