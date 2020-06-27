//
//  MainPanelPresentationAnimationView.swift
//  Muna
//
//  Created by Alexander on 6/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainPanelPresentationAnimationView: View {
    var isFirstLanch = true

    override func layout() {
        super.layout()

        if self.isFirstLanch {
            self.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)
            self.isFirstLanch = false
        }
    }

    func show() {
        self.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        let transform = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
        transform.damping = 8
        transform.speed = 2
        transform.fromValue = self.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(0, 0, 0)
        transform.duration = transform.settlingDuration

        self.layer?.transform = CATransform3DMakeTranslation(0, 0, 0)
        self.layer?.add(transform, forKey: #keyPath(CALayer.transform))
    }

    func hide(completion: VoidBlock?) {
        CATransaction.begin()
        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(self.frame.width, 0, 0)
        transform.duration = 0.25

        self.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        CATransaction.setCompletionBlock(completion)
        self.layer?.add(transform, forKey: #keyPath(CALayer.transform))
        CATransaction.commit()
    }
}
