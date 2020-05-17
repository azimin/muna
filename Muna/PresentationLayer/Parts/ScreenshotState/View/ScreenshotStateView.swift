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

        self.reminderSetupPopup.frame = self.positionForView(
            rect: self.reminderSetupPopup.frame,
            aroundRect: self.screenshotFrame
        )
        self.reminderSetupPopup.isHidden = false
        self.window?.makeFirstResponder(self.reminderSetupPopup.reminderTextField.textField)
        self.layoutSubtreeIfNeeded()
    }

    private func positionForView(rect: CGRect, aroundRect: CGRect) -> NSRect {
        var newRect = rect
        let rightSpace = self.bounds.maxX - aroundRect.maxX
        let leftSpace = aroundRect.minX
        let topSpace = aroundRect.minY
        let bottomSpace = self.bounds.maxY - aroundRect.maxY

        newRect.origin.y = aroundRect.minY

        let isEnoughRightSpace = rightSpace >= rect.width + 16
        let isEnoughLeftSpace = leftSpace >= rect.width + 16
        let isEnoughTopSpace = topSpace >= rect.height + 16
        let isEnoughBottomSpace = bottomSpace >= rect.height + 16

        if isEnoughRightSpace {
            newRect.origin.x = aroundRect.maxX + 16
            return newRect
        }

        if isEnoughLeftSpace {
            newRect.origin.x =  aroundRect.minX - newRect.width - 16
            return newRect
        }

        if isEnoughTopSpace && !isEnoughLeftSpace && !isEnoughRightSpace {
            newRect.origin.y = aroundRect.minY - newRect.height - 16
            return newRect
        }

        if isEnoughBottomSpace && !isEnoughLeftSpace && !isEnoughRightSpace {
            newRect.origin.y = aroundRect.maxY + 16
            return newRect
        }

        return newRect
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
//        self.setPositionForView(aroundRect: self.reminderSetupPopup.frame)
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
}
