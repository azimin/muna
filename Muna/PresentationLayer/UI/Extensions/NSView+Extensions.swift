//
//  NSView+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSView {
    func withIsHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
}
