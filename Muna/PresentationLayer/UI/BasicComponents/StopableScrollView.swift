//
//  StopableScrollView.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class StopableScrollView: NSScrollView {
    override func scrollWheel(with event: NSEvent) {
        if self.isStoped, event.phase != .began, event.phase != .mayBegin {
            return
        }
        self.isStoped = false
        super.scrollWheel(with: event)
    }

    var isStoped: Bool = false

    func stopScroll() {
        self.isStoped = true
    }
}
