//
//  ScreenShotStateViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ScreenShotStateViewController: NSViewController, ViewHolder {
    typealias ViewType = ScreenshotStateView

    var windowId: CGWindowID?

    var isFullscreenScreenshotState = false

    private var tmpCGImage: CGImage?

    private var mouseLocation: NSPoint { NSEvent.mouseLocation }

    private var startedPoint = NSPoint.zero

    var isNeededToDrawFrame = true

    private var hintTimer: Timer?
    private var passedTime = 0

    private let savingProcessingService: SavingProcessingService

    private var shortcutsController: ShortcutsController?

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        self.savingProcessingService = ServiceLocator.shared.savingService

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = ScreenshotStateView(delegate: self, savingService: self.savingProcessingService)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.showHintIfNeeded()
    }

    private func setup() {
        self.shortcutsController?.stop()
        self.shortcutsController = nil

        var shortcutActions: [ShortcutAction] = []
        for shortcut in Shortcut.allCases {
            let action = self.actionForShortcut(shortcut)
            shortcutActions.append(.init(
                item: shortcut.item,
                action: action
            ))
        }

        self.shortcutsController = ShortcutsController(
            shortcutActions: shortcutActions
        )
        self.shortcutsController?.start()
    }

    private var timer: Timer?
    var shouldUpdateCourser: Bool = false

    func runUpdateOfCursor() {
        self.stopUpdateOfCursorTimer()
        self.shouldUpdateCourser = true

        self.oldCursor = NSCursor.current

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.updateCursor()
        }
        RunLoop.main.add(self.timer!, forMode: .common)
    }

    func disaleUpdateScreenshot() {
        self.shouldUpdateCourser = false
    }

    func stopUpdateOfCursorTimer() {
        self.timer?.invalidate()

        let propertyString = CFStringCreateWithCString(kCFAllocatorDefault, "SetsCursorInBackground", 0)
        CGSSetConnectionProperty(_CGSDefaultConnection(), _CGSDefaultConnection(), propertyString, kCFBooleanTrue)

        if let cursor = self.oldCursor {
            cursor.set()
        } else {
            NSCursor.crosshair.pop()
        }
    }

    var oldCursor: NSCursor?

    func updateCursor() {
        guard self.shouldUpdateCourser == true else {
            return
        }

        let propertyString = CFStringCreateWithCString(kCFAllocatorDefault, "SetsCursorInBackground", 0)
        CGSSetConnectionProperty(_CGSDefaultConnection(), _CGSDefaultConnection(), propertyString, kCFBooleanTrue)
        NSCursor.crosshair.push()
    }

    // MARK: - Mouse events

    override func cursorUpdate(with event: NSEvent) {
        if self.shouldUpdateCourser {
            self.updateCursor()
        } else {
            super.cursorUpdate(with: event)
        }
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        guard self.isNeededToDrawFrame else {
            return
        }

        self.makeScreenshot { [unowned self] image in
            self.rootView.screenshotImageView.image = image
            self.rootView.screenshotImageView.isHidden = false

            self.startedPoint = self.view.convert(event.locationInWindow, from: nil)
            self.rootView.startDash()
        }
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)

        guard self.isNeededToDrawFrame else {
            return
        }

        self.isNeededToDrawFrame = false
        self.shouldUpdateCourser = false

        rootView.showVisuals()
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)

        self.stopUpdateOfCursorTimer()

        guard self.isNeededToDrawFrame else {
            return
        }

        self.updateCursor()

        let point = self.view.convert(event.locationInWindow, from: nil)
        self.rootView.continiouslyDrawDash(
            fromStartPoint: self.startedPoint,
            toPoint: point
        )
    }

    // MARK: - Show hide

    func show(isFullscreenScreenshotState: Bool) {
        self.setup()
        self.reset()

        self.shortcutsController?.start()

        if isFullscreenScreenshotState == false {
            self.runUpdateOfCursor()
        }
    }

    func hide(completion: VoidBlock?) {
        self.stopUpdateOfCursorTimer()
        self.disaleUpdateScreenshot()

        self.isNeededToDrawFrame = true
        self.reset()
        completion?()
    }

    func reset() {
        self.rootView.hideVisuals()
        self.shortcutsController?.stop()
    }

    // MARK: - Hint

    func showHintIfNeeded() {
        let nowTime = Date().timeIntervalSince1970
        let isBigGap = nowTime - Preferences.hintShowedForNotesTimeInterval > PresentationLayerConstants.oneHourInSeconds * 2

        guard (Preferences.isNeededToShowIncreaseProductivity && isBigGap) || Preferences.isFirstTimeOfShowingIncreaseProductivityPopup else { return }

        self.hintTimer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            guard self.passedTime >= 3 else {
                self.passedTime += 1
                return
            }

            let database = ServiceLocator.shared.itemsDatabase
            let numberOfCreatedItems = database.fetchItems(filter: .uncompleted).count

            if numberOfCreatedItems > 2 {
                ServiceLocator.shared.windowManager.showHintPopover(sender: self.rootView.reminderSetupPopup.shortcutsButton)
            }
            self.passedTime = 0
            Preferences.isFirstTimeOfShowingIncreaseProductivityPopup = false
            Preferences.hintShowedForNotesTimeInterval = Date().timeIntervalSince1970
            timer.invalidate()
            self.timer = nil
        }

        guard let timer = self.hintTimer else {
            appAssertionFailure("Timer can't be allocated on text task creation")
            return
        }

        RunLoop.current.add(timer, forMode: .common)
    }

    // MARK: - Make screenshot

    func makeScreenshot() {
        self.makeScreenshot { [unowned self] image in
            guard self.isNeededToDrawFrame else {
                return
            }

            self.isNeededToDrawFrame = false

            self.rootView.screenshotImageView.image = image
            self.rootView.screenshotImageView.isHidden = false

            self.startedPoint = .zero
            self.rootView.screenshotFrame = self.rootView.bounds

            self.rootView.showVisuals()
        }
    }

    func makeScreenshot(completion: @escaping (NSImage?) -> Void) {
        guard let windowId = self.windowId else {
            appAssertionFailure("Window id is nil")
            completion(nil)
            return
        }

        guard let screen = self.view.window?.screen else {
            appAssertionFailure("No screen")
            completion(nil)
            return
        }

        var rect = screen.frame
        rect.origin.y = 0
        let frame = screen.convertRectToPrimaryScreen(rect: rect)

        guard let cgImage = CGWindowListCreateImage(frame, .optionOnScreenBelowWindow, windowId, .bestResolution) else {
            appAssertionFailure("Screenshot handling is failed")
            completion(nil)
            return
        }

        self.tmpCGImage = cgImage

        let image = NSImage(cgImage: cgImage, size: self.view.frame.size)

        completion(image)
    }

    func actionForShortcut(_ shortcut: Shortcut) -> VoidBlock? {
        switch shortcut {
        case .closeItem:
            return { [weak self] in
                self?.rootView.handleCloseShortcut()
            }
        }
    }
}

extension ScreenShotStateViewController: ScreenshotStateViewDelegate {
    func escapeWasTapped() {
        ServiceLocator.shared.windowManager.closeHintPopover()
        self.isNeededToDrawFrame = true
        if self.isFullscreenScreenshotState {
            (NSApplication.shared.delegate as? AppDelegate)?.hideFullscreenScreenshotIfNeeded()
        } else {
            (NSApplication.shared.delegate as? AppDelegate)?.hideScreenshotIfNeeded()
        }
    }

    func saveImage(withRect rect: NSRect) {
        guard let cgImage = self.tmpCGImage else {
            appAssertionFailure("Image for save is nil")
            return
        }

        let newRect = NSRect(
            x: rect.minX * NSScreen.main!.backingScaleFactor,
            y: rect.minY * NSScreen.main!.backingScaleFactor,
            width: rect.width * NSScreen.main!.backingScaleFactor,
            height: rect.height * NSScreen.main!.backingScaleFactor
        )

        guard let croppedImage = cgImage.cropping(to: newRect) else {
            appAssertionFailure("Image processing is failed")
            return
        }

        let image = NSImage(cgImage: croppedImage, size: rect.size)

        self.savingProcessingService.addImage(image)

        self.tmpCGImage = nil
    }
}
