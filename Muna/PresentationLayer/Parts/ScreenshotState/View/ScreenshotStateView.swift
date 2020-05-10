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

    var screenshotFrame = CGRect.zero

    init(delegate: ScreenshotStateViewDelegate?) {
        self.delegate = delegate

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()

        self.setupInitialLayout()
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

        let saveFrame = NSRect(
            x: self.screenshotFrame.minX * NSScreen.main!.backingScaleFactor,
            y: self.screenshotFrame.minY * NSScreen.main!.backingScaleFactor,
            width: self.screenshotFrame.width * NSScreen.main!.backingScaleFactor,
            height: self.screenshotFrame.height * NSScreen.main!.backingScaleFactor
        )

        self.delegate?.saveImage(withRect: saveFrame)
    }

    func hideVisuals() {
        self.overlayView.clearOverlay()

        self.screenshotImageView.isHidden = true

        self.screenshotImageView.image = nil
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
