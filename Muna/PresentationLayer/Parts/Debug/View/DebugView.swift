//
//  DebugView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DebugView: View {
    let contentView = View()
//    let contentView = TaskCreateShortcuts()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
