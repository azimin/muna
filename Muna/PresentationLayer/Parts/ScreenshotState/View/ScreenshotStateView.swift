//
//  ScreenshotStateView.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

protocol ScreenshotStateViewDelegate: AnyObject {
    func escapeWasTapped()
    func saveImage(withRect rect: NSRect)
}

class ScreenshotStateView: View {
    override var isFlipped: Bool {
        return true
    }

    weak var delegate: ScreenshotStateViewDelegate?

    let screenshotImageView = ImageView()
    let overlayView = OverlayView()

    let taskCreateShortCutsView = TaskCreateShortcuts()

    let reminderSetupPopup: TaskCreateView

    var screenshotFrame = CGRect.zero

    init(delegate: ScreenshotStateViewDelegate?, savingService: SavingProcessingService) {
        self.delegate = delegate
        self.reminderSetupPopup = TaskCreateView(savingProcessingService: savingService)

        super.init(frame: .zero)

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupInitialLayout() {
        self.addSubview(self.screenshotImageView)
        self.screenshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(self.overlayView)
        self.overlayView.backgroundColor = .clear
        self.overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.screenshotImageView.isHidden = true

        self.addSubview(self.reminderSetupPopup)
        self.reminderSetupPopup.isHidden = true

        self.addSubview(self.taskCreateShortCutsView)
        self.taskCreateShortCutsView.isHidden = true
    }

    func startDash() {
        self.overlayView.startDash()
    }

    func continiouslyDrawDash(fromStartPoint startPoint: NSPoint, toPoint: NSPoint) {
        self.overlayView.continiouslyDrawDash(fromStartPoint: startPoint, toPoint: toPoint)

        self.screenshotFrame.origin = startPoint
        self.screenshotFrame.size.width = toPoint.x - startPoint.x
        self.screenshotFrame.size.height = toPoint.y - startPoint.y
    }

    func showVisuals() {
        guard self.screenshotFrame.width > 5, self.screenshotFrame.height > 5 else {
            self.hideVisuals()
            self.delegate?.escapeWasTapped()
            return
        }
        self.overlayView.showOverlay(atRect: self.screenshotFrame)

        self.delegate?.saveImage(withRect: self.screenshotFrame)

        self.setPositionForReminderPopupSetup()
        self.reminderSetupPopup.isHidden = false
        self.reminderSetupPopup.window?.makeFirstResponder(self.reminderSetupPopup)

        self.setPositionForTaskCreateShortcuts()
        self.taskCreateShortCutsView.isHidden = false
    }

    private func setPositionForReminderPopupSetup() {
        var popupFrame = self.reminderSetupPopup.frame
        let leftX: CGFloat
        let leftInsideX: CGFloat
        let rightX: CGFloat
        let maxRightPosition: CGFloat

        if self.screenshotFrame.size.width < 0 {
            leftX = self.screenshotFrame.minX - self.reminderSetupPopup.frame.width - 16
            leftInsideX = self.screenshotFrame.minX + 16
            rightX = self.screenshotFrame.maxX + 16
            maxRightPosition = self.screenshotFrame.maxX + 16 + popupFrame.width

        } else {
            leftX = self.screenshotFrame.origin.x - self.reminderSetupPopup.frame.width - 16
            leftInsideX = self.screenshotFrame.origin.x + 16
            rightX = self.screenshotFrame.maxX + 16
            maxRightPosition = self.screenshotFrame.maxX + 16 + popupFrame.width
        }

        if leftX < self.bounds.minX, maxRightPosition > self.bounds.maxX {
            popupFrame.origin.x = leftInsideX
        } else if leftX < self.bounds.minX {
            popupFrame.origin.x = rightX
        } else {
            popupFrame.origin.x = leftX
        }

        var normalY = self.screenshotFrame.minY - 16

        if normalY < self.bounds.minY {
            normalY = 16
        }

        popupFrame.origin.y = normalY

        self.reminderSetupPopup.frame = popupFrame
        self.layoutSubtreeIfNeeded()
    }

    private func setPositionForTaskCreateShortcuts() {
        var popupFrame = self.taskCreateShortCutsView.frame
        var x = self.reminderSetupPopup.frame.minX - popupFrame.width - 16

        if x < self.bounds.minX {
            x = self.reminderSetupPopup.frame.maxX + 16
        }

        if self.screenshotFrame.size.width < 0 {
            x = self.reminderSetupPopup.frame.minX + self.reminderSetupPopup.frame.width + 16
        }

        let normalY = self.reminderSetupPopup.frame.minY

        popupFrame.origin.x = x
        popupFrame.origin.y = normalY

        self.taskCreateShortCutsView.frame = popupFrame
        self.layoutSubtreeIfNeeded()
    }

    func hideVisuals() {
        self.overlayView.clearOverlay()

        self.screenshotFrame = .zero

        self.screenshotImageView.isHidden = true

        self.screenshotImageView.image = nil
        self.reminderSetupPopup.isHidden = true
        self.taskCreateShortCutsView.isHidden = true
        self.reminderSetupPopup.clear()
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // esc
        if event.keyCode == 53 {
            self.hideVisuals()
            self.delegate?.escapeWasTapped()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }
}
