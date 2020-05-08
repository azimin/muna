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

    init(delegate: ScreenshotStateViewDelegate?) {
        self.delegate = delegate

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
