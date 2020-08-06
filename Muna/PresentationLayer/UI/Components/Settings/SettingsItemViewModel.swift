//
//  SettingsModel.swift
//  Muna
//
//  Created by Egor Petrov on 06.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol SettingsItemViewModelDelegate: AnyObject {
    func launchOnStartupSwitcherSetup(withValue value: Bool)

    func pingIntervalSliderSetup(withValue value: Double, title: String)
    func periodOfStoringSliderSetup(withValue value: Double, title: String)
}

class SettingsItemViewModel {
    weak var delegate: SettingsItemViewModelDelegate?

    func setup() {
        self.setupLaunchOnStartup()
        self.setupPeriodOfStoring()
        self.setupPingInterval()
    }

    private func setupLaunchOnStartup() {
        self.delegate?.launchOnStartupSwitcherSetup(withValue: Preferences.launchOnStartup)
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
            self.delegate?.periodOfStoringSliderSetup(withValue: 0, title: value.rawValue)
        case .week:
            self.delegate?.periodOfStoringSliderSetup(withValue: 1, title: value.rawValue)
        case .month:
            self.delegate?.periodOfStoringSliderSetup(withValue: 2, title: value.rawValue)
        case .year:
            self.delegate?.periodOfStoringSliderSetup(withValue: 3, title: value.rawValue)
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
            self.delegate?.pingIntervalSliderSetup(withValue: 0, title: value.rawValue)
        case .tenMins:
            self.delegate?.pingIntervalSliderSetup(withValue: 1, title: value.rawValue)
        case .halfAnHour:
            self.delegate?.pingIntervalSliderSetup(withValue: 2, title: value.rawValue)
        case .hour:
            self.delegate?.pingIntervalSliderSetup(withValue: 3, title: value.rawValue)
        case .disabled:
            self.delegate?.pingIntervalSliderSetup(withValue: 4, title: value.rawValue)
        }
    }
}

extension SettingsItemViewModel: SettingsItemViewDelegate {
    func launchOnStartupSwitchChanged(onState state: NSControl.StateValue) {
        Preferences.launchOnStartup = state == .on
    }

    func pingIntervalSliderChanged(onValue value: Int) {
        let preferencesValue = Preferences.PingInterval.allCases[value]
        Preferences.pingInterval = preferencesValue.rawValue.lowercased()

        self.delegate?.pingIntervalSliderSetup(withValue: Double(value), title: preferencesValue.rawValue)
    }

    func periodOfStoringSliderChanged(onValue value: Int) {
        let preferencesValue = Preferences.PeriodOfStoring.allCases[value]
        Preferences.periodOfStoring = preferencesValue.rawValue.lowercased()

        self.delegate?.periodOfStoringSliderSetup(withValue: Double(value), title: preferencesValue.rawValue)
    }
}
