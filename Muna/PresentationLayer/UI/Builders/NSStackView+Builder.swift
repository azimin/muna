//
//  NSStackView+Builder.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSStackView {
    func withSpacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
