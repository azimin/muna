//
//  FlyEmojiView.swift
//  Muna
//
//  Created by Alexander on 4/8/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class FlyEmojiView: View {
    let emojiLabels: [Label] = []

    func runAnimation() {
        for j in 0...6 {
            let offset: CGFloat
            let step: CGFloat = 50
            let steps = Int(self.frame.width / step)

            if j % 4 == 0 {
                offset = 50
            } else if j % 4 == 1 {
                offset = 25
            } else if j % 4 == 2 {
                offset = 40
            } else {
                offset = 10
            }

            for i in 0...steps {
                let label = buildLabel()

                let start = CGPoint(
                    x: offset + step * CGFloat(i),
                    y: self.frame.maxY + 20
                )

                let end = CGPoint(
                    x: 50 + step * CGFloat(i),
                    y: -20
                )

                let time = Double.random(in: 0.1...0.6)
                let delay = Double.random(in: 0...0.3) + 0.2 * Double(j)

                self.runAnimation(label: label, from: start, to: end, duration: 1.5 + time, delay: delay)
            }
        }
    }

    private func buildLabel() -> Label {
        let label = Label(fontStyle: .bold, size: 22)
        label.wantsLayer = true
        label.text = "❤️"
        label.sizeToFit()
        self.addSubview(label)
        return label
    }

    private func runAnimation(label: Label, from: CGPoint, to: CGPoint, duration: Double, delay: Double) {

        label.layer?.position = to

        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fromValue = from
        animation.toValue = to

        label.layer?.add(animation, forKey: "fly")

        label.layer?.opacity = 0

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        opacityAnimation.duration = duration
        opacityAnimation.beginTime = CACurrentMediaTime() + delay
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0

        label.layer?.add(opacityAnimation, forKey: "opacity")
    }
}
