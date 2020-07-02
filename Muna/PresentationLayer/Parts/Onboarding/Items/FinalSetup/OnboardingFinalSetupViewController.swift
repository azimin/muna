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

    override func loadView() {
        self.view = OnboardingFinalSetupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.startupSettingItem.switcher.state = Preferences.launchOnStartup ? .on : .off

        self.rootView.startupSettingItem.switcher.target = self
        self.rootView.startupSettingItem.switcher.action = #selector(self.switchStateChanged)

        self.setupPeriodOfStoring()
        self.setupPingInterval()
    }

    @objc func buttonAction(sender: NSButton) {
        self.onNext?()
    }

    @objc
    func switchStateChanged() {
        Preferences.launchOnStartup = self.rootView.startupSettingItem.switcher.state == .on
    }

    private func setupPeriodOfStoring() {
        let value = Preferences.periodOfStoring

        switch value {
        case .day:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.storageSettingItem.slider.doubleValue = 1
        case .month:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.storageSettingItem.slider.doubleValue = 2
        case .week:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.storageSettingItem.slider.doubleValue = 3
        case .year:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.storageSettingItem.slider.doubleValue = 4
        }
    }

    private func setupPingInterval() {
        let value = Preferences.pingInterval

        switch value {
        case .fiveMins:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.notificationsSettingItem.slider.doubleValue = 1
        case .tenMins:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.notificationsSettingItem.slider.doubleValue = 2
        case .halfAnHour:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.notificationsSettingItem.slider.doubleValue = 3
        case .hour:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue
            self.rootView.notificationsSettingItem.slider.doubleValue = 4
        }
    }
}
