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

    let habitsTitleLabel = Label(fontStyle: .bold, size: 24)
        .withTextColorStyle(.titleAccent)
        .withText("Habits")

    let habitsDescriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("To learn habit of using new app we will remind about it ever time you will use next apps")
        .withAligment(.center)

    let thingsHabitView = CheckboxWithImageSettingView(
        image: NSImage(named: "things"),
        title: "Things",
        initialState: Preferences.splashOnThings ? .on : .off
    )
    let notesHabitView = CheckboxWithImageSettingView(
        image: NSImage(named: "notes"),
        title: "Notes",
        initialState: Preferences.splashOnNotes ? .on : .off
    )
    let remindersHabitView = CheckboxWithImageSettingView(
        image: NSImage(named: "reminders"),
        title: "Reminders",
        initialState: Preferences.splashOnReminders ? .on : .off
    )

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
            make.top.equalTo(self.habitsTitleLabel.snp.bottom).offset(24)
        }

        self.addSubview(self.thingsHabitView)
        self.thingsHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self.habitsTitleLabel)
        }

        self.addSubview(self.notesHabitView)
        self.notesHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.trailing.equalTo(self.thingsHabitView.snp.leading).inset(-30)
        }

        self.addSubview(self.remindersHabitView)
        self.remindersHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.leading.equalTo(self.thingsHabitView.snp.trailing).offset(15)
        }
    }
}
