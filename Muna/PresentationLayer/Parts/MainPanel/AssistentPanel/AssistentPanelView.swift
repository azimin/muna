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
    }
}
