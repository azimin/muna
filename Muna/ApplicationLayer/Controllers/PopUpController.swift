//
//  PopUpController.swift
//  Muna
//
//  Created by Alexander on 5/7/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

protocol PopUpControllerDelegate: class {
    func popUpControllerAskToShowCurrentItem(_ popUpController: PopUpController)
    func popUpControllerAskToHide(_ popUpController: PopUpController)
}

class PopUpController {
    enum UserState {
        case shown
        case hidden
    }

    private var state: UserState = .hidden
    weak var delegate: PopUpControllerDelegate?

    var timer: Timer?

    func hide() {
        self.state = .hidden
        self.delegate?.popUpControllerAskToHide(self)
        self.timer?.invalidate()
    }

    func toggle() {
        switch self.state {
        case .hidden:
            self.show()
        case .shown:
            self.hide()
        }
    }

    @objc
    func show() {
        self.state = .shown
        self.delegate?.popUpControllerAskToShowCurrentItem(self)
        self.timer?.invalidate()
    }

    func hideAndAddShowToQueueIfNeeded() {
        guard self.state == .shown else {
            return
        }

        self.delegate?.popUpControllerAskToHide(self)

        self.timer?.invalidate()
        self.timer = nil

        self.timer = Timer(timeInterval: 0.2, repeats: false, block: { [weak self] (timer) in
            guard let self = self, timer == self.timer else { return }
            if self.state == .shown {
                self.delegate?.popUpControllerAskToShowCurrentItem(self)
            }
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
}
