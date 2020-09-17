//
//  NSBezierPath+CGPath.swift
//  Muna
//
//  Created by Egor Petrov on 16.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let elementCount = self.elementCount

        if elementCount > 0 {
            var didClosePath = true

            for index in 0 ..< elementCount {
                let pathType = self.element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineTo:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveTo:
                    let control1 = CGPoint(x: points[1].x, y: points[1].y)
                    let control2 = CGPoint(x: points[2].x, y: points[2].y)
                    path.addCurve(to: CGPoint(x: points[0].x, y: points[0].y), control1: control1, control2: control2)
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    fatalError("Path is not supported: \(pathType)")
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}
