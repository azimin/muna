//
//  SettingsItemView.swift
//  Muna
//
//  Created by Egor Petrov on 06.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

protocol SettingsItemViewDelegate: class {

    func launchOnStartupSwitchChanged(onState state: NSSlider.StateValue)

    func pingIntervalSliderChanged(onValue value: Int)
    func periodOfStoringSliderChanged(onValue value: Int)
    
}

class SettingsItemView: NSView {

    weak var delegate: SettingsItemViewModelDelegate?

    let settingsTitleLabel = Label(fontStyle: .bold, size: 24)
        .withTextColorStyle(.titleAccent)
        .withText("General")

    let startupSettingItem = SwitcherSettingsItem()
    private var startupSettingItemTopConstraintToSuperView: Constraint?
    private var startupSettingItemTopConstraintToTitleLabel: Constraint?

    let notificationsSettingItem = SliderSettingsItem(minValue: 0, maxValue: 4)
    let storageSettingItem = SliderSettingsItem(minValue: 0, maxValue: 3)

    init(isNeededShowTitle: Bool, delegate: SettingsItemViewModelDelegate?) {
        self.delegate = delegate

        super.init(frame: .zero)

        self.settingsTitleLabel.isHidden = !isNeededShowTitle
        self.setupInitialLayout()

        if isNeededShowTitle {
            self.startupSettingItemTopConstraintToSuperView?.deactivate()
            self.startupSettingItemTopConstraintToTitleLabel?.activate()
        } else {
            self.startupSettingItemTopConstraintToSuperView?.activate()
            self.startupSettingItemTopConstraintToTitleLabel?.deactivate()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.addSubview(self.settingsTitleLabel)
        self.settingsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }

        self.startupSettingItem.titleLabel.text = "Launch on startup"
        self.startupSettingItem.descriptionLabel.text = "Start Muna automatically after system restart"
        self.addSubview(self.startupSettingItem)
        self.startupSettingItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            self.startupSettingItemTopConstraintToTitleLabel = make.top.equalTo(self.settingsTitleLabel.snp.bottom).offset(24).constraint
            self.startupSettingItemTopConstraintToSuperView = make.top.equalToSuperview().offset(24).constraint
        }

        self.notificationsSettingItem.titleLabel.text = "Ping interval"
        self.notificationsSettingItem.descriptionLabel.text = "Should remind again when you ignore reminder"
        self.notificationsSettingItem.sliderSectionLabel.text = "Month"
        self.addSubview(self.notificationsSettingItem)
        self.notificationsSettingItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.startupSettingItem.snp.bottom)
        }

        self.storageSettingItem.titleLabel.text = "History size"
        self.storageSettingItem.descriptionLabel.text = "How long to keep complited items"
        self.storageSettingItem.sliderSectionLabel.text = "Month"
        self.addSubview(self.storageSettingItem)
        self.storageSettingItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.notificationsSettingItem.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
