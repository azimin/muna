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

    var isNeededToDrawFrame = true

    override func loadView() {
        self.view = ScreenshotStateView(delegate: self)
    }

    // MARK: - Mouse events

    override func mouseDown(with event: NSEvent) {
        guard self.isNeededToDrawFrame else {
            return
        }

        self.startedPoint = self.view.convert(event.locationInWindow, from: nil)

        (self.view as! ScreenshotStateView).startDash()
    }

    override func mouseUp(with event: NSEvent) {
        self.isNeededToDrawFrame = false
        (self.view as! ScreenshotStateView).showVisuals()
    }

    override func mouseDragged(with event: NSEvent) {
        guard self.isNeededToDrawFrame else {
            return
        }

        let point = self.view.convert(event.locationInWindow, from: nil)
        (self.view as! ScreenshotStateView).continiouslyDrawDash(
            fromStartPoint: self.startedPoint,
            toPoint: point
        )
    }

    // MARK: - Show hide

    func hide(completion: VoidBlock?) {
        self.isNeededToDrawFrame = true
        (self.view as! ScreenshotStateView).hideVisuals()
        completion?()
    }
}

extension ScreenShotStateViewController: ScreenshotStateViewDelegate {
    func escapeWasTapped() {
        self.isNeededToDrawFrame = true
        (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotIfNeeded()
    }
}
