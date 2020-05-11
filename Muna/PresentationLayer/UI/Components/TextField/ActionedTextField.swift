//
//  ActionedTextField.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ActionedTextField: NSTextField {
    var isFocused: BoolBlock?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.wantsLayer = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.resignActive), name: NSControl.textDidEndEditingNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        self.setBorder(isFocused: true)
        return super.becomeFirstResponder()
    }

    @objc
    func resignActive(_ notification: Notification) {
        if notification.object as AnyObject? === self {
            self.setBorder(isFocused: false)
        }
    }

    func setBorder(isFocused: Bool) {
        self.isFocused?(isFocused)
    }
}
