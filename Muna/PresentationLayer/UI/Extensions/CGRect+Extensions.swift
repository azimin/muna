//
//  CGRect+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension CGRect {
    func intersectionPercentage(_ otherRect: CGRect) -> CGFloat {
        if !intersects(otherRect) { return 0 }
        let intersectionRect = intersection(otherRect)
        if intersectionRect == self || intersectionRect == otherRect { return 100 }
        let intersectionArea = intersectionRect.width * intersectionRect.height
        let area = width * height
        return (intersectionArea / area) * 100
    }
}
