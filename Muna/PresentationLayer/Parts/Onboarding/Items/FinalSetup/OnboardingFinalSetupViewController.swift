//
//  OnboardingFinalSetupViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OnboardingFinalSetupViewController: NSViewController, OnboardingContainerProtocol, ViewHolder {
    typealias ViewType = OnboardingFinalSetupView

    var onNext: VoidBlock?

    private let settingItemViewModel: SettingsItemViewModel

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        self.settingItemViewModel = SettingsItemViewModel()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = OnboardingFinalSetupView()
        self.settingItemViewModel.delegate = self.rootView.settingsItemView
        self.rootView.settingsItemView.delegate = self.settingItemViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.continueButton.target = self
        self.rootView.continueButton.action = #selector(self.buttonAction)

        self.rootView.notesHabitView.checkboxButton.target = self
        self.rootView.notesHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)
        
        self.rootView.thingsHabitView.checkboxButton.target = self
        self.rootView.thingsHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)

        self.rootView.remindersHabitView.checkboxButton.target = self
        self.rootView.remindersHabitView.checkboxButton.action = #selector(self.splashOnNotesActions)
        
        self.settingItemViewModel.setup()
    }

    @objc
    func splashOnThingsActions(sender: NSButton) {
        Preferences.splashOnThings = sender.state == .on
    }

    @objc
    func splashOnNotesActions(sender: NSButton) {
        Preferences.splashOnNotes = sender.state == .on
    }

    @objc func buttonAction(sender: NSButton) {
        Preferences.isNeededToShowOnboarding = false
        ServiceLocator.shared.windowManager.toggleWindow(.onboarding)
    }
}
