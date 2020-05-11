//
//  DebugView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DebugView: View {
    let centerView = View()
    let textField = TextField()
    let textField2 = TextField()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.centerView)
        self.centerView.backgroundColor = NSColor.color(.black)
        self.centerView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 400, height: 300))
        }

        self.centerView.addSubview(self.textField)

        self.textField.placeholder = "When to remind"

        self.textField.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(200)
        }

        self.centerView.addSubview(self.textField2)

        self.textField2.placeholder = "Comment"

        self.textField2.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.textField.snp.bottom).inset(50)
            maker.width.equalTo(200)
        }
    }
}
