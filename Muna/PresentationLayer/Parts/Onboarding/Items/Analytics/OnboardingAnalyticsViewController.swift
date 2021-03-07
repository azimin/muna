//
//  OnboardingAnalyticsViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.03.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class OnboardingAnalyticsViewController: NSViewController, OnboardingContainerProtocol, ViewHolder {
    typealias ViewType = OnboardingAnalyticsView

    var onNext: VoidBlock?

    override func loadView() {
        self.view = OnboardingAnalyticsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.rootView.continueButton.target = self
//        self.rootView.continueButton.action = #selector(self.buttonAction)

//        self.rootView.habitAppsView.notesHabitView.checkboxButton.target = self
//        self.rootView.habitAppsView.notesHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)
//
//        self.rootView.habitAppsView.thingsHabitView.checkboxButton.target = self
//        self.rootView.habitAppsView.thingsHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)
//
//        self.rootView.habitAppsView.remindersHabitView.checkboxButton.target = self
//        self.rootView.habitAppsView.remindersHabitView.checkboxButton.action = #selector(self.splashOnRemindersActions)

//        self.settingItemViewModel.setup()
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

    @objc func buttonAction(sender: NSButton) {
        Preferences.isNeededToShowOnboarding = false
        ServiceLocator.shared.windowManager.toggleWindow(.onboarding)
    }
}
