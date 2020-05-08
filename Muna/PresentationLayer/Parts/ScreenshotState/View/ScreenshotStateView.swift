//
//  ScreenshotStateView.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ScreenshotStateViewDelegate: class {

    func escapeWasTapped()
}

class ScreenshotStateView: View {

    weak var delegate: ScreenshotStateViewDelegate?
    private var shapeLayer: CAShapeLayer!

    let leftVisualView = View()
    let topVisualView = View()
    let rightVisualView = View()
    let bottomVisualView = View()

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

        self.topVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)

        self.rightVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)

        self.bottomVisualView.backgroundColor = NSColor.black.withAlphaComponent(0.3)
    }

    func startDash() {
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = NSColor.black.withAlphaComponent(0.3).cgColor
        shapeLayer.strokeColor = NSColor.white.cgColor
        shapeLayer.lineDashPattern = [10, 5]
        self.layer?.addSublayer(shapeLayer)

        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        shapeLayer.add(dashAnimation, forKey: "linePhase")
    }

    func continiouslyDrawDash(fromStartPoint startPoint: NSPoint, toPoint: NSPoint) {
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: NSPoint(x: startPoint.x, y: toPoint.y))
        path.addLine(to: toPoint)
        path.addLine(to: NSPoint(x: toPoint.x, y: startPoint.y))
        path.closeSubpath()
        self.shapeLayer.path = path

        self.screenshotFrame.origin = startPoint
        self.screenshotFrame.size.width = toPoint.x - startPoint.x
        self.screenshotFrame.size.height = toPoint.y - startPoint.y
    }

    func showVisuals() {
        self.shapeLayer.fillColor = NSColor.clear.cgColor

        self.addSubview(self.leftVisualView)
        self.leftVisualView.frame = CGRect(
            x: .zero,
            y: .zero,
            width: self.screenshotFrame.minX,
            height: self.bounds.height
        )

        self.addSubview(self.rightVisualView)
        self.rightVisualView.frame = CGRect(
            x: self.screenshotFrame.maxX,
            y: .zero,
            width: self.bounds.width - self.screenshotFrame.maxX,
            height: self.bounds.height
        )

        self.addSubview(self.topVisualView)
        self.topVisualView.frame = CGRect(
            x: self.screenshotFrame.minX,
            y: .zero,
            width: self.screenshotFrame.width,
            height: self.screenshotFrame.minY
        )
        self.addSubview(self.bottomVisualView)
        self.bottomVisualView.frame = CGRect(
            x: self.screenshotFrame.minX,
            y: self.screenshotFrame.maxY,
            width: self.screenshotFrame.width,
            height: self.bounds.height - self.screenshotFrame.minY
        )
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // esc
        if event.keyCode == 53 {
            self.shapeLayer = nil
            self.delegate?.escapeWasTapped()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }
}
