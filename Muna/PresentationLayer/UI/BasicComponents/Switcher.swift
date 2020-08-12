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

    private let switcher = NSSwitch()

    private func updateState() {
        if let action = self.action, let target = self.target {
            self.sendAction(action, to: target)
        }
        self.switcher.state = self.checked ? .on : .off
    }

    private func setup() {
        self.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.switcher.target = self
        self.switcher.action = #selector(self.switchStateChanged)

        self.updateState()
    }

    @objc
    private func switchStateChanged() {
        switch self.switcher.state {
        case .on:
            self.checked = true
        case .off:
            self.checked = false
        default:
            self.checked = false
        }
    }
}
