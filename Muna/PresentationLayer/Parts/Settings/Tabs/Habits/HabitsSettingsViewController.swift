//
//  HabitsSettingsViewController.swift
//  Muna
//
//  Created by Egor Petrov on 11.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class HabitsSettingsViewController: NSViewController, ViewHolder {
    typealias ViewType = HabitsSettingsView

    override func loadView() {
        self.view = HabitsSettingsView()
    }

    override func viewDidLoad() {
        self.title = "About"

        self.rootView.habitAppsView.notesHabitView.checkboxButton.target = self
        self.rootView.habitAppsView.notesHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)

        self.rootView.habitAppsView.thingsHabitView.checkboxButton.target = self
        self.rootView.habitAppsView.thingsHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)

        self.rootView.habitAppsView.remindersHabitView.checkboxButton.target = self
        self.rootView.habitAppsView.remindersHabitView.checkboxButton.action = #selector(self.splashOnRemindersActions)
    }

    @objc
    func splashOnThingsActions(sender: NSButton) {
        Preferences.splashOnThings = sender.state == .on
    }

    @objc
    func splashOnNotesActions(sender: NSButton) {
        Preferences.splashOnNotes = sender.state == .on
    }

    @objc
    func splashOnRemindersActions(sender: NSButton) {
        Preferences.splashOnReminders = sender.state == .on
    }
}
