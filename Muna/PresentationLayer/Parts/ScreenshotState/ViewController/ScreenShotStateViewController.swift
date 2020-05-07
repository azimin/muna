//
//  ScreenShotStateViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ScreenShotStateViewController: NSViewController {

    private var mouseLocation: NSPoint { NSEvent.mouseLocation }

    private var startedPoint = CGPoint.zero

    override func loadView() {
        self.view = ScreenShotStateView()
    }

    // MARK: - Kyes

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }

    // MARK: - Mouse events

    override func mouseDown(with event: NSEvent) {
        self.startedPoint = self.mouseLocation
    }

    override func mouseUp(with event: NSEvent) {
        
    }

    override func mouseDragged(with event: NSEvent) {
    }
}
