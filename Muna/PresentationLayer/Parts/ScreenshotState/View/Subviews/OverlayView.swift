//
//  OverlayView.swift
//  Muna
//
//  Created by Egor Petrov on 10.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OverlayView: View {
    private var dashLayer: CAShapeLayer?

    private var leftVisualShapeLayer: CALayer?
    private var bottomVisualShapeLayer: CALayer?
    private var rightVisualShapeLayer: CALayer?
    private var topVisualShapeLayer: CALayer?

    override var isFlipped: Bool {
        return true
    }

    func startDash() {
        self.dashLayer = CAShapeLayer()
        self.dashLayer?.lineWidth = 2.0
        self.dashLayer?.fillColor = CGColor.color(.backgroundOverlay)
        self.dashLayer?.strokeColor = NSColor.white.cgColor
        self.dashLayer?.lineDashPattern = [10, 5]

        guard let layer = self.dashLayer else { return }
        self.layer?.addSublayer(layer)

        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        self.dashLayer?.add(dashAnimation, forKey: "linePhase")
    }

    func continiouslyDrawDash(fromStartPoint startPoint: NSPoint, toPoint: NSPoint) {
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: NSPoint(x: startPoint.x, y: toPoint.y))
        path.addLine(to: toPoint)
        path.addLine(to: NSPoint(x: toPoint.x, y: startPoint.y))
        path.closeSubpath()
        self.dashLayer?.path = path
    }

    func showOverlay(atRect rect: NSRect) {
        self.dashLayer?.fillColor = NSColor.clear.cgColor

        self.leftVisualShapeLayer = CALayer()
        self.leftVisualShapeLayer?.backgroundColor = CGColor.color(.backgroundOverlay)
        self.layer?.insertSublayer(self.leftVisualShapeLayer!, at: 0)
        self.leftVisualShapeLayer?.frame = CGRect(
            x: .zero,
            y: .zero,
            width: rect.minX + 2,
            height: self.bounds.height
        )

        self.rightVisualShapeLayer = CALayer()
        self.rightVisualShapeLayer?.backgroundColor = CGColor.color(.backgroundOverlay)
        self.layer?.insertSublayer(self.rightVisualShapeLayer!, at: 0)
        self.rightVisualShapeLayer?.frame = CGRect(
            x: rect.maxX - 2,
            y: .zero,
            width: self.bounds.width - rect.maxX + 2,
            height: self.bounds.height
        )

        self.bottomVisualShapeLayer = CALayer()
        self.bottomVisualShapeLayer?.backgroundColor = CGColor.color(.backgroundOverlay)
        self.layer?.insertSublayer(self.bottomVisualShapeLayer!, at: 0)
        self.bottomVisualShapeLayer?.frame = CGRect(
            x: rect.minX + 2,
            y: .zero,
            width: rect.width - 4,
            height: rect.minY + 2
        )

        self.topVisualShapeLayer = CALayer()
        self.topVisualShapeLayer?.backgroundColor = CGColor.color(.backgroundOverlay)
        self.topVisualShapeLayer?.frame = CGRect(
            x: rect.minX + 2,
            y: rect.maxY - 2,
            width: rect.width - 4,
            height: self.bounds.height - rect.minY + 2
        )
        self.layer?.insertSublayer(self.topVisualShapeLayer!, at: 0)
    }

    func clearOverlay() {
        self.layer?.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }

        self.leftVisualShapeLayer = nil
        self.topVisualShapeLayer = nil
        self.rightVisualShapeLayer = nil
        self.bottomVisualShapeLayer = nil
        self.dashLayer = nil
    }
}
