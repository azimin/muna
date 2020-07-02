//
//  MainPanelItemSelectionView.swift
//  Muna
//
//  Created by Alexander on 6/29/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainPanelItemSelectionView: View {
    let gradient = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.layer?.addSublayer(self.gradient)
        self.gradient.locations = [0, 1]
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1, y: 1)
    }

    override func updateLayer() {
        super.updateLayer()

        let alpha: CGFloat = Theme.current == .light ? 0.25 : 0.05

        self.gradient.colors = [
            CGColor.color(.plateFullSelection).copy(alpha: alpha)!,
            CGColor.color(.plateFullSelection).copy(alpha: 0)!,
        ]
    }

    override func layout() {
        super.layout()
        self.gradient.frame = self.bounds
    }

    func passNewPosition(point: CGPoint) {
        let newPoint = self.window?.contentView?.convert(
            point,
            to: self
        ) ?? .zero

        var xStart = newPoint.x / self.frame.width
        var yStart = newPoint.y / self.frame.height

        xStart = max(min(xStart, 1), 0)
        yStart = max(min(yStart, 1), 0)

        if xStart > 0, xStart < 1, yStart > 0, yStart < 1 {
            xStart = round(xStart)
            yStart = round(yStart)
        }

        self.gradient.startPoint = CGPoint(x: xStart, y: yStart)
        self.gradient.endPoint = CGPoint(x: 1 - xStart, y: 1 - yStart)
    }
}
