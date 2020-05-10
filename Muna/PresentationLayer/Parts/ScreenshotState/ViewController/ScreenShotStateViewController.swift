//
//  ScreenShotStateViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ScreenShotStateViewController: NSViewController {
    private var mainDisplayID: CGDirectDisplayID {
        return CGMainDisplayID()
    }

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
        (self.view as! ScreenshotStateView).showVisuals { [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let image = self.makeScreenshot()
            }
        }
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

    // MARK: - Make screen shot

    func makeScreenshot() -> NSImage? {
        guard let cgImage = CGDisplayCreateImage(self.mainDisplayID, rect: self.view.frame) else {
            return nil
        }
        let image = NSImage(cgImage: cgImage, size: self.view.frame.size)
        return image
    }
}

extension ScreenShotStateViewController: ScreenshotStateViewDelegate {
    func escapeWasTapped() {
        self.isNeededToDrawFrame = true
        (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotIfNeeded()
    }
}
