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
        self.reminderSetupPopup.snp.makeConstraints { maker in
            maker.width.equalTo(300)
        }

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

        self.reminderSetupPopup.frame = self.positionForTaskCreationView(
            rect: self.reminderSetupPopup.frame,
            aroundRect: self.screenshotFrame
        )
        self.reminderSetupPopup.isHidden = false
        self.window?.makeFirstResponder(self.reminderSetupPopup.reminderTextField.textField)
        self.layoutSubtreeIfNeeded()
    }

    private func positionForTaskCreationView(rect: CGRect, aroundRect: CGRect) -> NSRect {
        var newRect = rect
        let rightSpace = self.bounds.maxX - aroundRect.maxX
        let leftSpace = aroundRect.minX
        let topSpace = aroundRect.minY
        let bottomSpace = self.bounds.maxY - aroundRect.maxY

        newRect.origin.y = aroundRect.minY

        let isEnoughRightSpace = rightSpace >= rect.width + 16
        let isEnoughLeftSpace = leftSpace >= rect.width + 16
        let isEnoughTopSpace = topSpace >= rect.height + 16
        let isEnoughBottomSpace = bottomSpace >= rect.height + 16 + 120

        if !isEnoughRightSpace, !isEnoughLeftSpace, !isEnoughTopSpace, !isEnoughBottomSpace {
            let centerX = aroundRect.midX - newRect.width / 2
            let centerY = aroundRect.midY - newRect.height / 2
            newRect.origin = CGPoint(x: centerX, y: centerY)
            return newRect
        }

        if isEnoughRightSpace {
            newRect.origin.x = aroundRect.maxX + 16
        }

        if isEnoughLeftSpace && !isEnoughRightSpace {
            newRect.origin.x = aroundRect.minX - newRect.width - 16
        }

        if isEnoughTopSpace && !isEnoughLeftSpace && !isEnoughRightSpace {
            newRect.origin.y = aroundRect.minY - newRect.height - 16
        }

        if isEnoughBottomSpace && !isEnoughLeftSpace && !isEnoughRightSpace && !isEnoughTopSpace {
            newRect.origin.y = aroundRect.maxY + 16
        }

        if !isEnoughBottomSpace {
            newRect.origin.y = self.bounds.maxY - newRect.height - 120
        }
        return newRect
    }

    private func positionForShortcutsView(rect: CGRect, aroundRect: CGRect) -> NSRect {
        var newRect = rect
        let rightSpace = self.bounds.maxX - aroundRect.maxX
        let leftSpace = aroundRect.minX
        let topSpace = aroundRect.minY
        let bottomSpace = self.bounds.maxY - aroundRect.maxY

        let rightSpaceFromScreenshot = self.bounds.maxX - self.screenshotFrame.maxX
        let leftSpaceFromScreenshot = self.screenshotFrame.minX
        let topSpaceFromScreenshot = self.screenshotFrame.minY
        let bottomSpaceFromScreenshot = self.bounds.maxY - self.screenshotFrame.maxY

        let isEnoughRightSpaceFromScreenshot = rightSpaceFromScreenshot >= rect.width + 16
        let isEnoughLeftSpaceFromScreenshot = leftSpaceFromScreenshot >= rect.width + 16
        let isEnoughTopSpaceFromScreenshot = topSpaceFromScreenshot >= rect.height + 16
        let isEnoughBottomSpaceFromScreenshot = bottomSpaceFromScreenshot >= rect.height + 16

        let isEnoughRightSpace = rightSpace >= rect.width + 16
        let isEnoughLeftSpace = leftSpace >= rect.width + 16
        let isEnoughTopSpace = topSpace >= rect.height + 16
        let isEnoughBottomSpace = bottomSpace >= rect.height + 16

        newRect.origin.y = aroundRect.minY

        if isEnoughRightSpace {
            newRect.origin.x = aroundRect.maxX + 16

            if !self.screenshotFrame.intersects(newRect) {
                return newRect
            }
        }

        if isEnoughLeftSpace {
            newRect.origin.x = aroundRect.minX - 16 - newRect.width

            if !self.screenshotFrame.intersects(newRect) {
                return newRect
            }
        }

        if isEnoughLeftSpace {
            newRect.origin.x = aroundRect.minX - 16 - newRect.width

            if !self.screenshotFrame.intersects(newRect) {
                return newRect
            }
        }

        if isEnoughTopSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.minY - 16 - newRect.height
        }

        if isEnoughBottomSpace, !isEnoughTopSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.maxY + 16
        }

        if self.bounds.minX > newRect.origin.x {
            newRect.origin.x = self.bounds.minX + 16
        }
        if self.bounds.maxX < newRect.maxX {
            newRect.origin.x = self.bounds.maxX - 16 - newRect.width
        }

        if !self.screenshotFrame.intersects(newRect) {
            return newRect
        }

        if isEnoughLeftSpaceFromScreenshot, isEnoughTopSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.minY - newRect.height - 16

            if self.screenshotFrame.intersects(newRect) {
                newRect.origin.x = self.screenshotFrame.minX - 16 - newRect.width
                return newRect
            }
        }

        if isEnoughLeftSpaceFromScreenshot, isEnoughBottomSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.maxY + 16

            if self.screenshotFrame.intersects(newRect) {
                newRect.origin.x = self.screenshotFrame.minX - 16 - newRect.width
                return newRect
            }
        }

        if isEnoughRightSpaceFromScreenshot, isEnoughTopSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.minY - newRect.height - 16

            if self.screenshotFrame.intersects(newRect) {
                newRect.origin.x = self.screenshotFrame.maxX + 16
                return newRect
            }
        }

        if isEnoughRightSpaceFromScreenshot, isEnoughBottomSpace {
            newRect.origin.x = aroundRect.midX - newRect.width / 2
            newRect.origin.y = aroundRect.maxY + 16

            if self.screenshotFrame.intersects(newRect) {
                newRect.origin.x = self.screenshotFrame.maxX + 16
                return newRect
            }
        }

        if isEnoughRightSpaceFromScreenshot {
            newRect.origin.y = self.screenshotFrame.midY - newRect.height / 2
            newRect.origin.x = self.screenshotFrame.maxX + 16

            if !aroundRect.intersects(newRect) {
                return newRect
            }
        }

        if isEnoughLeftSpaceFromScreenshot {
            newRect.origin.y = self.screenshotFrame.midY - newRect.height / 2
            newRect.origin.x = self.screenshotFrame.minX - 16 - newRect.width

            if !aroundRect.intersects(newRect) {
                return newRect
            }
        }

        if isEnoughTopSpaceFromScreenshot {
            newRect.origin.x = self.screenshotFrame.midX - newRect.width / 2
            newRect.origin.y = self.screenshotFrame.minY - newRect.height - 16

            if !aroundRect.intersects(newRect) {
                newRect.origin.x = aroundRect.maxX + 16
            }
            return newRect
        }

        if isEnoughBottomSpaceFromScreenshot {
            newRect.origin.x = self.screenshotFrame.midX - newRect.width / 2
            newRect.origin.y = self.screenshotFrame.maxY + 16

            if !aroundRect.intersects(newRect) {
                newRect.origin.x = aroundRect.maxX + 16
            }
            return newRect
        }

        newRect.origin.y = aroundRect.midY - newRect.height / 2

        if isEnoughRightSpace {
            newRect.origin.x = aroundRect.maxX + 16
        }

        if isEnoughLeftSpace {
            newRect.origin.x = aroundRect.minX - 16 - newRect.width
        }

        if self.bounds.minY > newRect.origin.y {
            newRect.origin.y = self.bounds.minY + 16
        }

        if self.bounds.maxY < newRect.maxY {
            newRect.origin.y = self.bounds.maxY - 16 - newRect.height
        }

        return newRect
    }

    func hideVisuals() {
        self.overlayView.clearOverlay()

        self.screenshotFrame = .zero

        self.screenshotImageView.isHidden = true

        self.screenshotImageView.image = nil
        self.reminderSetupPopup.isHidden = true
        self.handleCloseShortcutsButton()
        self.reminderSetupPopup.clear()
    }

    func showShortcutsView(aroundViewFrame frame: NSRect) {
        self.taskCreateShortCutsView.frame = self.positionForShortcutsView(
            rect: self.taskCreateShortCutsView.frame,
            aroundRect: frame
        )
        self.taskCreateShortCutsView.isHidden = false
        self.isShortcutsViewShowed = true
        self.layoutSubtreeIfNeeded()
    }

    @objc
    private func handleCloseShortcutsButton() {
        self.taskCreateShortCutsView.isHidden = true
        self.isShortcutsViewShowed = false
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.keyCode == Key.escape.carbonKeyCode {
            self.hideVisuals()
            self.delegate?.escapeWasTapped()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }

    func handleCloseShortcut() {
        if self.isShortcutsViewShowed {
            self.handleCloseShortcutsButton()
        } else {
            self.delegate?.escapeWasTapped()
        }
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

    func closeScreenshot() {
        self.delegate?.escapeWasTapped()
    }
}
