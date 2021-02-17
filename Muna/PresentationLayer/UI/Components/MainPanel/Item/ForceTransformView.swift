//
//  ForceTransformView.swift
//  Muna
//
//  Created by Alexander on 2/18/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class ForceTransformLayer: CALayer {
    var forceTransform: CATransform3D = CATransform3DConcat(CATransform3DMakeScale(1, 1, 1), CATransform3DMakeTranslation(0, 0, 0))

    override var transform: CATransform3D {
        didSet {
            if CATransform3DEqualToTransform(self.transform, self.forceTransform) == false {
                self.transform = forceTransform
            }
        }
    }
}

class ForceTransformView: View {
    var forceTransform: CATransform3D? {
        get {
            return (self.layer as? ForceTransformLayer)?.forceTransform
        }
        set {
            if let value = newValue {
                (self.layer as? ForceTransformLayer)?.forceTransform = value
            }
        }
    }

    override func makeBackingLayer() -> CALayer {
        return ForceTransformLayer()
    }
}
