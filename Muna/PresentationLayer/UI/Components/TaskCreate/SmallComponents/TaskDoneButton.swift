//
//  TaskDoneButton.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskDoneButton: Button {
    let separator = View()
    let overlay = View()
    let label = Label(fontStyle: .bold, size: 15)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.title = ""

        self.wantsLayer = true
        self.snp.makeConstraints { maker in
            maker.height.equalTo(50)
        }

        self.addSubview(self.separator)
        self.separator.backgroundColor = NSColor.color(.separator)
        self.separator.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(1)
        }

        self.addSubview(self.overlay)
        self.overlay.backgroundColor = NSColor.color(.lightOverlay)
        self.overlay.snp.makeConstraints { maker in
            maker.top.equalTo(self.separator.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }

        self.addSubview(self.label)
        self.label.text = "Done"
        self.label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
