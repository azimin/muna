//
//  DebugView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DebugView: View {
    let contentView = TaskCreateView(savingProcessingService: ServiceLocator.shared.savingService)

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
            maker.width.equalTo(220)
        }
    }
}
