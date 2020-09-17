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
        }
    }

    private func setupInitialLayout() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func drawInitialPath(inRect rect: NSRect) {
        self.backgroundCountDownLayer.lineWidth = 2
        self.backgroundCountDownLayer.strokeColor = NSColor.windowBackgroundColor.withAlphaComponent(0.6).cgColor
        self.backgroundCountDownLayer.strokeEnd = 1
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
        self.countDownLayer.strokeColor = NSColor.windowBackgroundColor.cgColor
        self.countDownLayer.strokeEnd = 1
        self.countDownLayer.lineCap = .round
        self.countDownLayer.fillColor = nil

        let countDownPath = NSBezierPath(
            ovalIn: NSRect(
                x: rect.origin.x + 2,
                y: rect.origin.y + 2,
                width: rect.width - 4,
                height: rect.height - 4
            )
        )
        self.backgroundCountDownLayer.path = countDownPath.cgPath
        self.layer?.addSublayer(self.countDownLayer)
    }
}
