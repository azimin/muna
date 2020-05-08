//
//  PanelBottomBarView.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class PanelBottomBarView: View {
    let appNameLabel = Label(
        fontStyle: .heavy,
        size: 12
    )
    .withTextColorStyle(.white60alpha)
    .withText("Muna")

    let buttonsStackView = NSStackView()
        .withSpacing(16)
    let shortcutsButton = Button().withImageName("icon_cmd", color: .white60)
    let settingsButton = Button().withImageName("icon_settings_2", color: .white60)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.snp.makeConstraints { maker in
            maker.height.equalTo(46)
        }

        self.addSubview(self.appNameLabel)
        self.appNameLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(16)
        }

        self.addSubview(self.buttonsStackView)
        self.buttonsStackView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(16)
            maker.centerY.equalToSuperview()
        }

        for button in [self.shortcutsButton, self.settingsButton] {
            button.snp.makeConstraints { maker in
                maker.size.equalTo(16)
            }
        }

        self.buttonsStackView.addArrangedSubview(self.shortcutsButton)
        self.buttonsStackView.addArrangedSubview(self.settingsButton)
    }
}