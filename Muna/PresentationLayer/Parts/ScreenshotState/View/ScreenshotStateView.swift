//
//  ScreenshotStateView.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ScreenshotStateViewDelegate: AnyObject {
    func escapeWasTapped()
}

class ScreenshotStateView: View {
    weak var delegate: ScreenshotStateViewDelegate?
    private var shapeLayer: CAShapeLayer?

    let leftVisualView = View()
    let bottomVisualView = View()
    let rightVisualView = View()
    let topVisualView = View()

    var screenshotFrame = CGRect.zero

    init(delegate: ScreenshotStateViewDelegate?) {
        self.delegate = delegate

        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.leftVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)

        self.bottomVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)

        self.rightVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)

        self.topVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)
    }

    func startDash() {
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer?.lineWidth = 2.0
        self.shapeLayer?.fillColor = NSColor.black.withAlphaComponent(0.3).cgColor
        self.shapeLayer?.strokeColor = NSColor.white.cgColor
        self.shapeLayer?.lineDashPattern = [10, 5]

        guard let layer = shapeLayer else { return }
        self.layer?.addSublayer(layer)

        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        self.shapeLayer?.add(dashAnimation, forKey: "linePhase")
    }

    func continiouslyDrawDash(fromStartPoint startPoint: NSPoint, toPoint: NSPoint) {
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: NSPoint(x: startPoint.x, y: toPoint.y))
        path.addLine(to: toPoint)
        path.addLine(to: NSPoint(x: toPoint.x, y: startPoint.y))
        path.closeSubpath()
        self.shapeLayer?.path = path

        self.screenshotFrame.origin = startPoint
        self.screenshotFrame.size.width = toPoint.x - startPoint.x
        self.screenshotFrame.size.height = toPoint.y - startPoint.y
    }

    func showVisuals() {
        self.shapeLayer?.fillColor = NSColor.clear.cgColor

        self.layer?.insertSublayer(self.leftVisualView.layer!, at: 0)
        self.leftVisualView.frame = CGRect(
            x: .zero,
            y: .zero,
            width: self.screenshotFrame.minX + 2,
            height: self.bounds.height
        )

        self.layer?.insertSublayer(self.rightVisualView.layer!, at: 0)
        self.rightVisualView.frame = CGRect(
            x: self.screenshotFrame.maxX - 2,
            y: .zero,
            width: self.bounds.width - self.screenshotFrame.maxX,
            height: self.bounds.height
        )

        self.layer?.insertSublayer(self.bottomVisualView.layer!, at: 0)
        self.bottomVisualView.frame = CGRect(
            x: self.screenshotFrame.minX + 2,
            y: .zero,
            width: self.screenshotFrame.width - 4,
            height: self.screenshotFrame.minY + 2
        )

        self.layer?.insertSublayer(self.topVisualView.layer!, at: 0)
        self.topVisualView.frame = CGRect(
            x: self.screenshotFrame.minX + 2,
            y: self.screenshotFrame.maxY - 2,
            width: self.screenshotFrame.width - 4,
            height: self.bounds.height - self.screenshotFrame.minY
        )
    }

    private func hideVisuals() {
        self.layer?.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }

        self.shapeLayer = nil
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
