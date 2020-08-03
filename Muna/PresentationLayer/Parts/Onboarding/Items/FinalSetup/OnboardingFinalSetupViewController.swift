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

        self.rootView.notificationsSettingItem.slider.target = self
        self.rootView.notificationsSettingItem.slider.action = #selector(self.pingIntervalSliderChanged)

        self.rootView.storageSettingItem.slider.target = self
        self.rootView.storageSettingItem.slider.action = #selector(self.storagePeriodSliderChanged)

        self.rootView.continueButton.target = self
        self.rootView.continueButton.action = #selector(self.buttonAction)

        self.setupPeriodOfStoring()
        self.setupPingInterval()
    }

    private func setupPeriodOfStoring() {
        let value: Preferences.PeriodOfStoring
        if let settingsValue = Preferences.PeriodOfStoring(rawValue: Preferences.periodOfStoring.lowercased()) {
            value = settingsValue
        } else {
            assertionFailure("Not supproted period of storing: \(Preferences.pingInterval)")
            value = .week
        }

        switch value {
        case .day:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.storageSettingItem.slider.doubleValue = 0
        case .week:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.storageSettingItem.slider.doubleValue = 1
        case .month:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.storageSettingItem.slider.doubleValue = 2
        case .year:
            self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.storageSettingItem.slider.doubleValue = 3
        }
    }

    private func setupPingInterval() {
        let value: Preferences.PingInterval
        if let settingsValue = Preferences.PingInterval(rawValue: Preferences.pingInterval.lowercased()) {
            value = settingsValue
        } else {
            assertionFailure("Not supproted pingInterval: \(Preferences.pingInterval)")
            value = .fiveMins
        }

        switch value {
        case .fiveMins:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.notificationsSettingItem.slider.doubleValue = 0
        case .tenMins:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.notificationsSettingItem.slider.doubleValue = 1
        case .halfAnHour:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.notificationsSettingItem.slider.doubleValue = 2
        case .hour:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.notificationsSettingItem.slider.doubleValue = 3
        case .disabled:
            self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
            self.rootView.notificationsSettingItem.slider.doubleValue = 4
        }
    }

    @objc func buttonAction(sender: NSButton) {
        ServiceLocator.shared.windowManager.toggleWindow(.onboarding)
    }

    @objc
    func switchStateChanged() {
        Preferences.launchOnStartup = self.rootView.startupSettingItem.switcher.state == .on
    }

    @objc
    func pingIntervalSliderChanged() {
        var newValue = self.rootView.notificationsSettingItem.slider.doubleValue
        newValue.round(.up)
        switch newValue {
        case 0 ..< 1:
            self.rootView.notificationsSettingItem.slider.doubleValue = 0
        case 1 ..< 2:
            self.rootView.notificationsSettingItem.slider.doubleValue = 1
        case 2 ..< 3:
            self.rootView.notificationsSettingItem.slider.doubleValue = 2
        case 3:
            self.rootView.notificationsSettingItem.slider.doubleValue = 3
        default:
            break
        }

        let value = Preferences.PingInterval.allCases[Int(newValue)]
        Preferences.pingInterval = value.rawValue.lowercased()

        self.rootView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
    }

    @objc
    func storagePeriodSliderChanged() {
        var newValue = self.rootView.storageSettingItem.slider.doubleValue
        newValue.round(.up)
        switch newValue {
        case 0 ..< 1:
            self.rootView.storageSettingItem.slider.doubleValue = 0
        case 1 ..< 2:
            self.rootView.storageSettingItem.slider.doubleValue = 1
        case 2 ..< 3:
            self.rootView.storageSettingItem.slider.doubleValue = 2
        case 3:
            self.rootView.storageSettingItem.slider.doubleValue = 3
        default:
            break
        }

        let value = Preferences.PeriodOfStoring.allCases[Int(newValue)]
        Preferences.periodOfStoring = value.rawValue.lowercased()

        self.rootView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
    }
}
