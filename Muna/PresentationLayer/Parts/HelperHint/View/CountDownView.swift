//
//  CountDownView.swift
//  Muna
//
//  Created by Egor Petrov on 14.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class CountDownView: View {
    let backgroundCountDownLayer = CAShapeLayer()
    let countDownLayer = CAShapeLayer()

    var isNeededToDrawPath = true

    let label = Label(fontStyle: .heavy, size: 9)
        .withTextColorStyle(.titleAccent)
        .withAligment(.center)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()

        self.backgroundCountDownLayer.frame = self.bounds
        self.countDownLayer.frame = self.bounds

        if self.isNeededToDrawPath {
            self.drawInitialPath(inRect: self.bounds)
            self.countDownLayer.transform = CATransform3DMakeRotation(45, 0, 0, 1)
            self.countDownLayer.frame.origin.y = -2
            self.countDownLayer.frame.origin.x = 17
        }
    }

    private func setupInitialLayout() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func drawInitialPath(inRect rect: NSRect) {
        self.backgroundCountDownLayer.lineWidth = 2
        self.backgroundCountDownLayer.strokeColor = ColorStyle.title60Accent.color.cgColor
        self.backgroundCountDownLayer.lineCap = .round
        self.backgroundCountDownLayer.fillColor = nil

        let backgroundPath = NSBezierPath(
            ovalIn: NSRect(
                x: rect.origin.x + 2,
                y: rect.origin.y + 2,
                width: rect.width - 4,
                height: rect.height - 4
            )
        )
        self.backgroundCountDownLayer.path = backgroundPath.cgPath
        self.layer?.addSublayer(self.backgroundCountDownLayer)

        self.countDownLayer.lineWidth = 2
        self.countDownLayer.strokeColor = ColorStyle.titleAccent.color.cgColor
        self.countDownLayer.lineCap = .round
        self.countDownLayer.fillColor = nil

        let countDownPath = NSBezierPath()
        countDownPath.appendArc(
            withCenter: NSPoint(x: 14, y: 14),
            radius: 12,
            startAngle: .pi / 2.0 * 3.0,
            endAngle: .pi / 2 * 3.0 + .pi * 2.0,
            clockwise: true
        )
        self.countDownLayer.path = countDownPath.cgPath
        self.layer?.addSublayer(self.countDownLayer)
    }
}
