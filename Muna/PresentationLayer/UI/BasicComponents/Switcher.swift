//
//  Switcher.swift
//  Muna
//
//  Created by Alexander on 8/12/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Switcher: NSControl {
    var checked: Bool = false {
        didSet {
            self.updateState()
        }
    }

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let switcher: NSView = {
        if #available(OSX 10.15, *) {
            return NSSwitch()
        } else {
            let button = NSButton()
            button.setButtonType(.switch)
            return button
        }
    }()

    private func updateState() {
        if let action = self.action, let target = self.target {
            self.sendAction(action, to: target)
        }

        if #available(OSX 10.15, *) {
            if let view = self.switcher as? NSSwitch {
                view.state = self.checked ? .on : .off
            }
        } else {
            if let view = self.switcher as? NSButton {
                view.state = self.checked ? .on : .off
            }
        }
    }

    private func setup() {
        self.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        if #available(OSX 10.15, *) {
            if let view = self.switcher as? NSSwitch {
                view.target = self
                view.action = #selector(self.switchStateChanged)
            }
        } else {
            if let view = self.switcher as? NSButton {
                view.target = self
                view.action = #selector(self.switchStateChanged)
            }
        }

        self.updateState()
    }

    @objc
    private func switchStateChanged() {
        if #available(OSX 10.15, *) {
            if let view = self.switcher as? NSSwitch {
                self.checked = view.state == .on ? true : false
            }
        } else {
            if let view = self.switcher as? NSButton {
                self.checked = view.state == .on ? true : false
            }
        }
    }
}
