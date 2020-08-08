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
    let titleLabel = Label(
        fontStyle: .semibold,
        size: 18
    )
    .withTextColorStyle(.titleAccent)

    let infoLabel = Label(
        fontStyle: .medium,
        size: 13
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
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(
                NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            )
        }

        self.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titleLabel.snp.leading)
            maker.top.equalTo(self.titleLabel.snp.bottom).inset(-2)
            maker.bottom.equalToSuperview()
        }

        self.addSubview(self.redArrowView)
        self.redArrowView.backgroundColor = NSColor.color(.redDots)
        self.redArrowView.layer?.cornerRadius = 5
        self.redArrowView.snp.makeConstraints { maker in
            maker.leading.equalTo(titleLabel.snp.trailing)
            maker.top.equalTo(self.titleLabel.snp.top).inset(-2)
            maker.size.equalTo(10)
        }
    }
}
