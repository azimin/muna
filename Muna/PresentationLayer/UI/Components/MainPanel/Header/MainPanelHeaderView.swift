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
    let label = Label(
        fontStyle: .medium,
        size: 20
    )
    .withTextColorStyle(.title60AccentAlpha)

    let redArrowView = View()

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
        self.label.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(
                NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            )
            maker.bottom.equalToSuperview().inset(4)
        }

        self.addSubview(self.redArrowView)
        self.redArrowView.backgroundColor = NSColor.color(.redDots)
        self.redArrowView.layer?.cornerRadius = 5
        self.redArrowView.snp.makeConstraints { maker in
            maker.leading.equalTo(label.snp.trailing)
            maker.top.equalTo(self.label.snp.top).inset(-2)
            maker.size.equalTo(10)
        }
    }
}
