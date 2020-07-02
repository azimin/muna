//
//  MousePositionService.swift
//  Muna
//
//  Created by Alexander on 6/29/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class MousePositionService {
    static var shared = MousePositionService()

    var mousePosition = Observable<CGPoint>(.zero)

    private var timer: Timer?

    func start() {
        self.stop()
        self.timer = Timer(timeInterval: 0.05, repeats: true) { _ in
            self.mousePosition.value = NSEvent.mouseLocation
        }
        RunLoop.main.add(self.timer!, forMode: .common)
    }

    func stop() {
        self.timer?.invalidate()
    }
}
