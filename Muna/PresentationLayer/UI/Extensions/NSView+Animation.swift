//
//  NSView+Animation.swift
//  Muna
//
//  Created by Alexander on 8/19/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-8, 8, -6, 6, -5, 5, -2, 2, 0]
        layer?.add(animation, forKey: "shake")
    }
}
