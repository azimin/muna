//
//  PopUpController.swift
//  Muna
//
//  Created by Alexander on 5/7/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

protocol PopUpControllerDelegate: AnyObject {
    func popUpControllerAskToShowCurrentItem(_ popUpController: PopUpController)
    func popUpControllerAskToHide(_ popUpController: PopUpController)
}

class PopUpController {
    enum UserState {
        case shown
        case shouldShow
        case hidden
    }

    private var state: UserState = .hidden
    weak var delegate: PopUpControllerDelegate?

    var timer: Timer?
    var popover: NSPopover?

    private var isPopOverShown: Bool {
        return self.popover?.isShown == true
    }

    var isHidden: Bool {
        return self.popover?.isShown != true
    }

    func hide() {
        self.state = .hidden
        self.delegate?.popUpControllerAskToHide(self)
        self.timer?.invalidate()
    }

    func toggle() {
        switch self.state {
        case .hidden, .shown:
            if self.isPopOverShown {
                self.hide()
            } else {
                self.show()
            }
        case .shouldShow:
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
        if self.state == .hidden {
            return
        }

        if self.state == .shown {
            guard self.isPopOverShown else {
                return
            }
        }

        self.state = .shouldShow
        self.delegate?.popUpControllerAskToHide(self)

        self.timer?.invalidate()
        self.timer = nil

        self.timer = Timer(timeInterval: 0.2, repeats: false, block: { [weak self] timer in
            guard let self = self, timer == self.timer else { return }
            if self.state == .shouldShow {
                self.delegate?.popUpControllerAskToShowCurrentItem(self)
            }
        })
        RunLoop.current.add(self.timer!, forMode: .common)
    }
}
