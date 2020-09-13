//
//  HabitsSettingsView.swift
//  Muna
//
//  Created by Egor Petrov on 11.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

final class HabitsSettingsView: View, SettingsViewProtocol {
    let titlesView = View()
    let settingsView = View()

    let habitsTitleLabel = Label(fontStyle: .bold, size: 16)
        .withTextColorStyle(.titleAccent)
        .withText("Habits")

    let habitsDescriptionLabel = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.title60Accent)
        .withText("To learn habit of using new app we will remind about it ever time you will use next apps")
        .withAligment(.center)

    let habitAppsView = HabitAppsView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.addSubview(self.titlesView)
        self.titlesView.snp.makeConstraints { maker in
            maker.leading.top.bottom.equalToSuperview()
            maker.width.equalTo(self.firstPartframeWidth)
            maker.height.equalTo(260)
        }

        self.addSubview(self.settingsView)
        self.settingsView.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titlesView.snp.trailing)
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(self.frameWidth - 120)
        }

        self.addSubview(self.habitsTitleLabel)
        self.habitsTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }

        self.addSubview(self.habitsDescriptionLabel)
        self.habitsDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.habitsTitleLabel.snp.bottom).offset(8)
        }

        self.addSubview(self.habitAppsView)
        self.habitAppsView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(30)
            make.centerX.equalTo(self.habitsTitleLabel)
        }
    }
}
