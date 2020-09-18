//
//  AssistentPanelView.swift
//  Muna
//
//  Created by Alexander on 9/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class AssistentPanelView: MainPanelBackgroundView {
    let titleLabel = Label(
        fontStyle: .semibold,
        size: 18
    )
    .withTextColorStyle(.titleAccent)
    .withText("Smart Assistent")

    let infoLabel = Label(
        fontStyle: .medium,
        size: 13
    )
    .withTextColorStyle(.title60AccentAlpha)
    .withText("0 items")

    let scrollView = NSScrollView()
    let contentView = NSStackView(orientation: .vertical, alignment: .centerX, distribution: .fill)

    override func updateLayer() {
        super.updateLayer()

        self.titleLabel.applyGradientText(colors: [
            ColorStyle.assitentLeftColor.color.cgColor,
            ColorStyle.assitentRightColor.color.cgColor,
        ])
    }

    override func viewSetup() {
        super.viewSetup()

        self.backgroundView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(16)
            maker.leading.equalToSuperview().inset(16)
        }

        self.backgroundView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titleLabel.snp.leading)
            maker.top.equalTo(self.titleLabel.snp.bottom).inset(-2)
        }

//        self.scrollView.documentView = self.contentView
//        self.addSubview(self.scrollView)
//        self.scrollView.snp.makeConstraints { maker in
//            maker.edges.equalToSuperview()
//        }

        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(66)
            make.leading.trailing.equalToSuperview()
        }

        let item = ServiceLocator.shared.itemsDatabase.fetchItems(filter: .all).first
        let firstAssistent = AssistentItemView(assistentItem: .popularItem(item: item!))
        let secondAssistent = AssistentItemView(assistentItem: .usageHint(hintItem: .previewImage))
        let thirdAssistent = AssistentItemView(assistentItem: .shortcutOfTheDay(shortcut: .init(key: .t, modifiers: .command)))

        self.contentView.addArrangedSubview(firstAssistent)
        self.contentView.addArrangedSubview(secondAssistent)
        self.contentView.addArrangedSubview(thirdAssistent)

        for view in [firstAssistent, secondAssistent, thirdAssistent] {
            view.snp.makeConstraints { make in
                make.width.equalTo(WindowManager.panelWindowFrameWidth - 32)
            }
        }
    }
}
