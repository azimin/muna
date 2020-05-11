//
//  TaskDoneButton.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskDoneButton: Button {
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
        self.layer?.borderWidth = 1
        self.layer?.borderColor = CGColor.color(.separator)
        self.layer?.backgroundColor = CGColor.color(.white).copy(alpha: 0.1)
        self.snp.makeConstraints { maker in
            maker.height.equalTo(50)
        }

        self.addSubview(self.label)
        self.label.text = "Done"
        self.label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
