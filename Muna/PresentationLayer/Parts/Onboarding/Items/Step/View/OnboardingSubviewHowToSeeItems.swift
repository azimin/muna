//
//  OnboardingSubviewHowToSeeItems.swift
//  Muna
//
//  Created by Alexander on 6/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class OnboardingSubviewHowToSeeItems: View {
    let panelShorcutView = ShortcutView(item: Preferences.DefaultItems.defaultActivationShortcut.item)

    let panelShorcutLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("To open your reminders control pane")

    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("You can preview, group, edit or mark your reminders as complete from here")

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.panelShorcutView)
        self.panelShorcutView.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview()
        }

        self.addSubview(self.panelShorcutLabel)
        self.panelShorcutLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(self.panelShorcutView.snp.centerY)
            maker.leading.equalTo(self.panelShorcutView.snp.trailing).inset(-12)
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.panelShorcutView.snp.bottom).inset(-12)
            maker.leading.equalToSuperview()
        }
    }
}
