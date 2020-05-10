//
//  ScreenShotStateViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ScreenShotStateViewController: NSViewController {
    var windowId: CGWindowID?

    private var mouseLocation: NSPoint { NSEvent.mouseLocation }

    private var startedPoint = NSPoint.zero

    var isNeededToDrawFrame = true

    override func loadView() {
        self.view = ScreenshotStateView(delegate: self)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
    }

    // MARK: - Mouse events

    override func mouseDown(with event: NSEvent) {
        guard self.isNeededToDrawFrame else {
            return
        }

        self.makeScreenshot { [unowned self] image in
            (self.view as! ScreenshotStateView).screenshotImageView.image = image
            (self.view as! ScreenshotStateView).screenshotImageView.isHidden = false

            self.startedPoint = self.view.convert(event.locationInWindow, from: nil)
            (self.view as! ScreenshotStateView).startDash()
        }
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

    // MARK: - Make screen shot

    private let directoryURL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("ReminderPictures", isDirectory: true)

    func makeScreenshot(completion: @escaping (NSImage?) -> Void) {
        guard let windowId = self.windowId else {
            assertionFailure("Window id is nil")
            completion(nil)
            return
        }

        guard let cgImage = CGWindowListCreateImage(NSScreen.main!.frame, .optionOnScreenBelowWindow, windowId, .bestResolution) else {
            assertionFailure("Screenshot handling is failed")
            completion(nil)
            return
        }

        let image = NSImage(cgImage: cgImage, size: self.view.frame.size)
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        let jpgData = bitmap.representation(using: .jpeg, properties: [:])
        do {
            try FileManager.default.createDirectory(at: self.directoryURL, withIntermediateDirectories: true, attributes: nil)
            try jpgData?.write(to: self.directoryURL.appendingPathComponent("Hello.jpg"), options: .atomic)
        } catch {
            print(error)
        }

        completion(image)
    }
}

extension ScreenShotStateViewController: ScreenshotStateViewDelegate {
    func escapeWasTapped() {
        self.isNeededToDrawFrame = true
        (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotIfNeeded()
    }
}
