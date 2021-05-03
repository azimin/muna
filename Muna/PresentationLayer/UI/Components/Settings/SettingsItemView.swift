//
//  SettingsItemView.swift
//  Muna
//
//  Created by Egor Petrov on 06.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

protocol SettingsItemViewDelegate: AnyObject {
    func useAnalyticsSwitchChanged(onState state: Bool)
    func showPassedItemsSwitchChanged(onState state: Bool)
    func launchOnStartupSwitchChanged(onState state: Bool)

    func pingIntervalSliderChanged(onValue value: Int)
    func periodOfStoringSliderChanged(onValue value: Int, isNeededToUpdate: Bool)

    func periodOfStoringCancelTap()
    func periodOfStoringOkTap(withValue value: Int)
}

class SettingsItemView: NSView {
    enum Style {
        case big
        case small
        case oneLine
    }

    weak var delegate: SettingsItemViewDelegate?

    let settingsTitleLabel = Label(fontStyle: .bold, size: 18)
        .withTextColorStyle(.titleAccent)
        .withText("General")

    let useAnalyticsSwitcherItem: SwitcherSettingsItem
    let showPassedTasksItem: SwitcherSettingsItem
    let startupSettingItem: SwitcherSettingsItem

    let notificationsSettingItem: SliderSettingsItem
    let storageSettingItem: SliderSettingsItem

    init(isNeededShowTitle: Bool, style: Style, needToShake: Bool) {
        self.showPassedTasksItem = SwitcherSettingsItem(style: style)
        self.useAnalyticsSwitcherItem = SwitcherSettingsItem(style: style)
        self.startupSettingItem = SwitcherSettingsItem(style: style)
        self.notificationsSettingItem = SliderSettingsItem(minValue: 0, maxValue: 4, style: style)
        self.storageSettingItem = SliderSettingsItem(minValue: 0, maxValue: 3, style: style)

        super.init(frame: .zero)

        self.settingsTitleLabel.isHidden = !isNeededShowTitle
        self.showPassedTasksItem.isHidden = isNeededShowTitle
        self.useAnalyticsSwitcherItem.isHidden = isNeededShowTitle
        self.setupInitialLayout(isNeededShowTitle: isNeededShowTitle)

        self.useAnalyticsSwitcherItem.switcher.target = self
        self.useAnalyticsSwitcherItem.switcher.action = #selector(self.useAnalyticsSwitchStateChanged)

        self.showPassedTasksItem.switcher.target = self
        self.showPassedTasksItem.switcher.action = #selector(self.passedItemsSwitchStateChanged)

        self.startupSettingItem.switcher.target = self
        self.startupSettingItem.switcher.action = #selector(self.switchStateChanged)

        self.notificationsSettingItem.slider.target = self
        self.notificationsSettingItem.slider.action = #selector(self.pingIntervalSliderChanged)

        self.storageSettingItem.slider.target = self
        self.storageSettingItem.slider.action = #selector(self.storagePeriodSliderChanged)

        if needToShake {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.startupSettingItem.shake()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout(isNeededShowTitle: Bool) {
        self.addSubview(self.settingsTitleLabel)
        self.settingsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }

        let contentStackView = NSStackView(
            orientation: .vertical,
            alignment: .leading,
            distribution: .fill
        )
        contentStackView.spacing = 0

        self.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

        self.startupSettingItem.titleLabel.text = "Launch on startup"
        self.startupSettingItem.setDescription("Muna will open automatically upon system restart")
        contentStackView.addArrangedSubview(self.startupSettingItem)
        contentStackView.setCustomSpacing(isNeededShowTitle ? 10 : 24, after: self.startupSettingItem)

        self.showPassedTasksItem.titleLabel.text = "Number of uncompleted tasks"
        self.showPassedTasksItem.setDescription("Show number of uncompleted tasks")
        contentStackView.addArrangedSubview(self.showPassedTasksItem)
        contentStackView.setCustomSpacing(24, after: self.showPassedTasksItem)

        self.useAnalyticsSwitcherItem.titleLabel.text = "Share anonymous usage data"
        self.useAnalyticsSwitcherItem.setDescription(
            "We report this events to Amplitude for usage data and use App Center for crash reports.",
            withLink: "https://www.notion.so/muna0/Muna-Analytics-66145c7e8d41495bb84d01a3c9b63663",
            linkedPart: "this events"
        )
        contentStackView.addArrangedSubview(self.useAnalyticsSwitcherItem)
        contentStackView.setCustomSpacing(10, after: self.useAnalyticsSwitcherItem)

        self.notificationsSettingItem.titleLabel.text = "Ping frequency"
        self.notificationsSettingItem.descriptionLabel.text = "Set the length of time between pings"
        self.notificationsSettingItem.sliderSectionLabel.text = "Month"
        contentStackView.addArrangedSubview(self.notificationsSettingItem)

        self.storageSettingItem.titleLabel.text = "Reminder Archive"
        self.storageSettingItem.descriptionLabel.text = "Set how long to keep completed reminders"
        self.storageSettingItem.sliderSectionLabel.text = "Month"
        contentStackView.addArrangedSubview(self.storageSettingItem)
    }

    @objc
    func useAnalyticsSwitchStateChanged() {
        self.delegate?.useAnalyticsSwitchChanged(onState: self.useAnalyticsSwitcherItem.switcher.checked)
    }

    @objc
    func switchStateChanged() {
        self.delegate?.launchOnStartupSwitchChanged(onState: self.startupSettingItem.switcher.checked)
    }

    @objc
    func passedItemsSwitchStateChanged() {
        self.delegate?.showPassedItemsSwitchChanged(onState: self.showPassedTasksItem.switcher.checked)
    }

    @objc
    func pingIntervalSliderChanged() {
        var newValue = self.notificationsSettingItem.slider.doubleValue
        switch newValue {
        case 0 ..< 0.6:
            newValue = 0
        case 0.6 ..< 1, 1 ..< 1.6:
            newValue = 1
        case 1.6 ..< 2, 2 ..< 2.6:
            newValue = 2
        case 2.6 ..< 3, 3 ..< 3.6:
            newValue = 3
        case 3.6 ..< 4, 4:
            newValue = 4
        default:
            break
        }

        self.delegate?.pingIntervalSliderChanged(onValue: Int(newValue))
    }

    @objc
    func storagePeriodSliderChanged() {
        var newValue = self.storageSettingItem.slider.doubleValue
        switch newValue {
        case 0 ..< 0.6:
            newValue = 0
        case 0.6 ..< 1, 1 ..< 1.6:
            newValue = 1
        case 1.6 ..< 2, 2 ..< 2.6:
            newValue = 2
        case 2.6 ..< 3, 3:
            newValue = 3
        default:
            break
        }

        let event = NSApplication.shared.currentEvent
        let isNeededToUpdate = event?.type == NSEvent.EventType.leftMouseUp
        self.delegate?.periodOfStoringSliderChanged(onValue: Int(newValue), isNeededToUpdate: isNeededToUpdate)
    }
}

extension SettingsItemView: SettingsItemViewModelDelegate {
    func showAlert(forValue value: Int) {
        let alert = NSAlert()
        alert.messageText = "Are you sure?"
        alert.informativeText = "You changing the period of storing to less than present it will remove old items. This cannot be undone"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok")
        alert.addButton(withTitle: "Cancel")

        if let window = self.window {
            alert.beginSheetModal(for: window) { [unowned self] response in
                if response == .alertFirstButtonReturn {
                    self.delegate?.periodOfStoringOkTap(withValue: value)
                }
                if response == .alertSecondButtonReturn {
                    self.delegate?.periodOfStoringCancelTap()
                }
            }
        }
    }

    func useAnalyticsItemSwitcherSetup(withValue value: Bool) {
        self.useAnalyticsSwitcherItem.switcher.checked = value
    }

    func showPassedItemsSwitcherSetup(withValue value: Bool) {
        self.showPassedTasksItem.switcher.checked = value
    }

    func launchOnStartupSwitcherSetup(withValue value: Bool) {
        self.startupSettingItem.switcher.checked = value
    }

    func pingIntervalSliderSetup(withValue value: Double, title: String) {
        self.notificationsSettingItem.slider.doubleValue = value
        self.notificationsSettingItem.sliderSectionLabel.text = title.capitalized
    }

    func periodOfStoringSliderSetup(withValue value: Double, title: String) {
        self.storageSettingItem.slider.doubleValue = value
        self.storageSettingItem.sliderSectionLabel.text = title.capitalized
    }
}
