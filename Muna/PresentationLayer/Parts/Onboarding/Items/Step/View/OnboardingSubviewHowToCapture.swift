//
//  OnboardingSubviewHowToCapture.swift
//  Muna
//
//  Created by Alexander on 6/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class OnboardingSubviewHowToCapture: View {
    let partShorcutView = ShortcutView(item: Preferences.DefaultItems.defaultScreenshotShortcut.item)

    let partShorcutLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("Capture Visual Note")

    let fullShorcutView = ShortcutView(item: Preferences.DefaultItems.defaultShortcutFullscreenScreenshotShortcut.item)

    let fullShorcutLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("Capture Text Note")

    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("As simple as doing screenshot")

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.partShorcutView)
        self.partShorcutView.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview()
        }

        self.addSubview(self.partShorcutLabel)
        self.partShorcutLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(self.partShorcutView.snp.centerY)
            maker.leading.equalTo(self.partShorcutView.snp.trailing).inset(-12)
        }

        self.addSubview(self.fullShorcutView)
        self.fullShorcutView.snp.makeConstraints { maker in
            maker.top.equalTo(self.partShorcutView.snp.bottom).inset(-12)
            maker.leading.equalToSuperview()
        }

        self.addSubview(self.fullShorcutLabel)
        self.fullShorcutLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(self.fullShorcutView.snp.centerY)
            maker.leading.equalTo(self.fullShorcutView.snp.trailing).inset(-12)
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.fullShorcutView.snp.bottom).inset(-12)
            maker.leading.equalToSuperview()
        }
    }
}
