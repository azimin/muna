//
//  ScreenShotStateView.swift
//  Muna
//
//  Created by Egor Petrov on 07.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ScreenShotStateView: View {

    private var shapeLayer: CAShapeLayer!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startDash() {
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
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
}
