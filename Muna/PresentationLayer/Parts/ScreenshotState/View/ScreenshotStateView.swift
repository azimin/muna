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

    let taskCreateShortCutsView = TaskCreateShortcuts(style: .withoutShortcutsButton)

    let reminderSetupPopup: TaskCreateView

    var screenshotFrame = CGRect.zero

    private var isShortcutsViewShowed = false

    init(delegate: ScreenshotStateViewDelegate?, savingService: SavingProcessingService) {
        self.delegate = delegate
        self.reminderSetupPopup = TaskCreateView(savingProcessingService: savingService)

        super.init(frame: .zero)

        self.reminderSetupPopup.delegate = self

        self.taskCreateShortCutsView.closeButton.action = #selector(self.handleCloseShortcutsButton)

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

        if popupFrame.maxY > self.bounds.maxY {
            popupFrame.origin.y = self.bounds.minY - 16 - popupFrame.size.height
        }

        self.reminderSetupPopup.frame = popupFrame
        self.layoutSubtreeIfNeeded()
    }

    private func setPositionForTaskCreateShortcuts(aroundRect rect: CGRect) {
        var popupFrame = self.taskCreateShortCutsView.frame
        popupFrame.origin.x = rect.minX - 16 - popupFrame.width
        popupFrame.origin.y = rect.origin.y

        if popupFrame.origin.x < self.bounds.minX {
            popupFrame.origin.x = rect.maxX + 16

            if self.screenshotFrame.intersects(popupFrame), rect.maxY + 16 + popupFrame.height < self.bounds.maxY {
                popupFrame.origin.x = rect.origin.x
                popupFrame.origin.y = rect.maxY + 16
            }

            if self.screenshotFrame.intersects(popupFrame), rect.minY - 16 - popupFrame.height > self.bounds.minY {
                popupFrame.origin.x = rect.origin.x
                popupFrame.origin.y = rect.origin.y - 16 - popupFrame.height
            }
        }

        if popupFrame.maxY > self.bounds.maxY {
            popupFrame.origin.y = self.bounds.maxY - popupFrame.height - 16
        }

        if self.screenshotFrame.intersects(popupFrame), rect.maxX + 16 + popupFrame.width < self.bounds.maxX {
            popupFrame.origin.x = rect.maxX + 16

            if self.screenshotFrame.intersects(popupFrame) {
                popupFrame.origin.x = rect.origin.x
            }

            if self.screenshotFrame.intersects(popupFrame), self.screenshotFrame.origin.x + self.screenshotFrame.size.width + 16 + popupFrame.width < self.bounds.maxX {
                popupFrame.origin.y = rect.origin.y
                popupFrame.origin.x = self.screenshotFrame.origin.x + self.screenshotFrame.size.width + 16
            }
        }

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

    func showShortcutsView(aroundViewFrame frame: NSRect) {
        self.setPositionForTaskCreateShortcuts(aroundRect: self.reminderSetupPopup.frame)
        self.taskCreateShortCutsView.isHidden = false
        self.isShortcutsViewShowed = true
    }

    @objc
    private func handleCloseShortcutsButton() {
        self.taskCreateShortCutsView.isHidden = true
        self.isShortcutsViewShowed = false
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

extension ScreenshotStateView: TaskCreateViewDelegate {
    func shortcutsButtonTapped() {
        if self.isShortcutsViewShowed {
            self.handleCloseShortcutsButton()
        } else {
            self.showShortcutsView(aroundViewFrame: self.reminderSetupPopup.frame)
        }
    }
}
