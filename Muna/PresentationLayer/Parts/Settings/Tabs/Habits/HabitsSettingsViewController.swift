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

        self.rootView.notesHabitView.checkboxButton.target = self
        self.rootView.notesHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)

        self.rootView.thingsHabitView.checkboxButton.target = self
        self.rootView.thingsHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)

        self.rootView.remindersHabitView.checkboxButton.target = self
        self.rootView.remindersHabitView.checkboxButton.action = #selector(self.splashOnRemindersActions)
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
