//
//  ShortcutDescriptionView.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutDescriptionView: View {
    let titleLabel = Label(fontStyle: .medium, size: 15)
        .withTextColorStyle(.white)
    let subtitleLabel = Label(fontStyle: .regular, size: 12)
        .withTextColorStyle(.white60alpha)

    let shortcutContainerView = View()
    let shortcutView: ShortcutView

    init(title: String, subtitle: String, shortcutItems: [ShortcutItem]) {
        self.shortcutView = ShortcutView(oneOfItem: shortcutItems)
        super.init(frame: .zero)
        self.setup()

        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.alignment = .left
//        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.titleLabel.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview()
        }

        self.addSubview(self.subtitleLabel)
        self.subtitleLabel.alignment = .left
        self.subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.subtitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.titleLabel.snp.bottom)
            maker.leading.bottom.equalToSuperview()
//            maker.trailing.equalTo(self.titleLabel.snp.trailing)
        }

        self.addSubview(self.shortcutContainerView)
        self.shortcutContainerView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).inset(-8)
            maker.leading.greaterThanOrEqualTo(self.subtitleLabel.snp.trailing).inset(-8)
        }

        self.shortcutContainerView.addSubview(self.shortcutView)
        self.shortcutView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
        }
    }
}
