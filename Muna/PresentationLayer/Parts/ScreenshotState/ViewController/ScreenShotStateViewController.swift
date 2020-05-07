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

    private var startedPoint = NSPoint.zero

    override func loadView() {
        self.view = ScreenShotStateView()
    }

    // MARK: - Kyes

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // esc
        if event.keyCode == 53 {
            (self.view as! ScreenShotStateView).removeLayer()
            (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotState()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }

    // MARK: - Mouse events

    override func mouseDown(with event: NSEvent) {

        self.startedPoint = self.view.convert(event.locationInWindow, from: nil)

        (self.view as! ScreenShotStateView).startDash()
    }

    override func mouseUp(with event: NSEvent) {
        (self.view as! ScreenShotStateView).removeLayer()
        (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotState()
    }

     override func mouseDragged(with event: NSEvent) {

        let point = self.view.convert(event.locationInWindow, from: nil)
        (self.view as! ScreenShotStateView).continiouslyDrawDash(
            fromStartPoint: self.startedPoint,
            toPoint: point
        )
    }

    // MARK: - Show hide

    func show() {
    }

     func hide(completion: VoidBlock?) {
        completion?()
    }
}
