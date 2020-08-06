//
//  SettingsModel.swift
//  Muna
//
//  Created by Egor Petrov on 06.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol SettingsItemViewModelDelegate: AnyObject {
    func pingIntervalSliderSetup(withValue value: Double, title: String)
    func periodOfStoringSliderSetup(withValue value: Double, title: String)
}

class SettingsItemViewModel {
    weak var delegate: SettingsItemViewModelDelegate?

    init(delegate: SettingsItemViewModelDelegate?) {
        self.delegate = delegate
    }

    private func setupPeriodOfStoring() {
        let value: Preferences.PeriodOfStoring
        if let settingsValue = Preferences.PeriodOfStoring(rawValue: Preferences.periodOfStoring.lowercased()) {
            value = settingsValue
        } else {
            appAssertionFailure("Not supproted period of storing: \(Preferences.pingInterval)")
            value = .week
        }

        switch value {
        case .day:
            self.delegate?.periodOfStoringSliderSetup(withValue: 0, title: value.rawValue.capitalized)
        case .week:
            self.delegate?.periodOfStoringSliderSetup(withValue: 1, title: value.rawValue.capitalized)
        case .month:
            self.delegate?.periodOfStoringSliderSetup(withValue: 2, title: value.rawValue.capitalized)
        case .year:
            self.delegate?.periodOfStoringSliderSetup(withValue: 3, title: value.rawValue.capitalized)
        }
    }

    private func setupPingInterval() {
        let value: Preferences.PingInterval
        if let settingsValue = Preferences.PingInterval(rawValue: Preferences.pingInterval.lowercased()) {
            value = settingsValue
        } else {
            appAssertionFailure("Not supproted pingInterval: \(Preferences.pingInterval)")
            value = .fiveMins
        }

        switch value {
        case .fiveMins:
            self.delegate?.pingIntervalSliderSetup(withValue: 0, title: value.rawValue.capitalized)
        case .tenMins:
            self.delegate?.pingIntervalSliderSetup(withValue: 1, title: value.rawValue.capitalized)
        case .halfAnHour:
            self.delegate?.pingIntervalSliderSetup(withValue: 2, title: value.rawValue.capitalized)
        case .hour:
            self.delegate?.pingIntervalSliderSetup(withValue: 3, title: value.rawValue.capitalized)
        case .disabled:
            self.delegate?.pingIntervalSliderSetup(withValue: 4, title: value.rawValue.capitalized)
        }
    }

    func switchStateChanged() {
        Preferences.launchOnStartup = self.rootView.settingsItemView.startupSettingItem.switcher.state == .on
    }

    func pingIntervalSliderChanged() {
        var newValue = self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue
        newValue.round(.up)
        switch newValue {
        case 0 ..< 1:
            self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue = 0
        case 1 ..< 2:
            self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue = 1
        case 2 ..< 3:
            self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue = 2
        case 3 ..< 4:
            self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue = 3
        case 4:
            self.rootView.settingsItemView.notificationsSettingItem.slider.doubleValue = 4
        default:
            break
        }

        let value = Preferences.PingInterval.allCases[Int(newValue)]
        Preferences.pingInterval = value.rawValue.lowercased()

        self.rootView.settingsItemView.notificationsSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
    }

    func storagePeriodSliderChanged() {
        var newValue = self.rootView.settingsItemView.storageSettingItem.slider.doubleValue
        newValue.round(.up)
        switch newValue {
        case 0 ..< 1:
            self.rootView.settingsItemView.storageSettingItem.slider.doubleValue = 0
        case 1 ..< 2:
            self.rootView.settingsItemView.storageSettingItem.slider.doubleValue = 1
        case 2 ..< 3:
            self.rootView.settingsItemView.storageSettingItem.slider.doubleValue = 2
        case 3:
            self.rootView.settingsItemView.storageSettingItem.slider.doubleValue = 3
        default:
            break
        }

        let value = Preferences.PeriodOfStoring.allCases[Int(newValue)]
        Preferences.periodOfStoring = value.rawValue.lowercased()

        self.rootView.settingsItemView.storageSettingItem.sliderSectionLabel.text = value.rawValue.capitalized
    }
}
