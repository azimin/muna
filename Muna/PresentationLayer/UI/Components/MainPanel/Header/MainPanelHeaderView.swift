//
//  MainPanelHeaderView.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class MainPanelHeaderView: View, GenericCellSubview, ReusableView, NSCollectionViewSectionHeaderView {
    let label = Label(fontStyle: .bold, size: 18)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

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
            maker.leading.trailing.equalToSuperview().inset(
                NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            )
            maker.bottom.equalToSuperview().inset(4)
        }
    }
}
