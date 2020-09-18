//
//  HabitAppsView.swift
//  Muna
//
//  Created by Alexander on 9/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

final class HabitAppsView: View {
    let stackView = NSStackView(
        orientation: .horizontal,
        alignment: .top,
        distribution: .fill
    )

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

    override func viewSetup() {
        super.viewSetup()

        self.stackView.spacing = 30
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.stackView.addArrangedSubview(self.thingsHabitView)
        self.stackView.addArrangedSubview(self.notesHabitView)
        self.stackView.addArrangedSubview(self.remindersHabitView)
    }
}
