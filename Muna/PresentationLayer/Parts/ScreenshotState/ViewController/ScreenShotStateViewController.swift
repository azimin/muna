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
        self.view = ScreenshotStateView(delegate: self)
    }

    // MARK: - Mouse events

    override func mouseDown(with event: NSEvent) {

        self.startedPoint = self.view.convert(event.locationInWindow, from: nil)

        (self.view as! ScreenshotStateView).startDash()
    }

    override func mouseUp(with event: NSEvent) {
    }

     override func mouseDragged(with event: NSEvent) {

        let point = self.view.convert(event.locationInWindow, from: nil)
        (self.view as! ScreenshotStateView).continiouslyDrawDash(
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

extension ScreenShotStateViewController: ScreenshotStateViewDelegate {
    func escapeWasTapped() {
        (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotIfNeeded()
    }
}
