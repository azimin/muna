//
//  MainPanelHeaderView.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class MainPanelHeaderView: View, GenericCellSubview {
    let label = Label(fontStyle: .bold, size: 18)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.label)
        self.label.textColor = NSColor.color(.white)
        self.label.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(
                NSEdgeInsets(top: 2, left: 16, bottom: 0, right: 16)
            )
        }
    }
}
