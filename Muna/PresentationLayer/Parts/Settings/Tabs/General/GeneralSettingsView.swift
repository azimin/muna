//
//  GeneralSettingsView.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import LaunchAtLogin

class GeneralSettingsView: View, SettingsViewProtocol {
    let titlesView = View()
    let settingsView = View()

    let launchOnStartupLabel = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.titleAccent)
        .withText("Startup:")
    let launchCheckbox = NSButton()

    let historySizeLabel = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.titleAccent)
        .withText("Completed item storage:")
    let historySizeController = NSSlider()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.titlesView)
        self.titlesView.snp.makeConstraints { maker in
            maker.leading.top.bottom.equalToSuperview()
            maker.width.equalTo(self.firstPartframeWidth)
            maker.height.equalTo(250)
        }

        self.addSubview(self.settingsView)
        self.settingsView.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titlesView.snp.trailing)
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(self.frameWidth - 120)
        }

        self.titlesView.addSubview(self.launchOnStartupLabel)
        self.launchOnStartupLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(22)
            maker.top.equalToSuperview().inset(22)
        }

        self.launchCheckbox.setButtonType(.switch)
        self.launchCheckbox.title = "Launch Muna on system startup"
        self.settingsView.addSubview(self.launchCheckbox)
        self.launchCheckbox.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(0)
            maker.centerY.equalTo(self.launchOnStartupLabel.snp.centerY)
        }
        self.launchCheckbox.target = self
        self.launchCheckbox.action = #selector(self.launchAtLoginToggle)
        self.updateLaunchButton()

        self.titlesView.addSubview(self.historySizeLabel)
        self.historySizeLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(22)
            maker.top.equalTo(self.launchCheckbox.snp.bottom).inset(-30)
        }

        self.settingsView.addSubview(self.historySizeController)
        self.historySizeController.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(0)
            maker.centerY.equalTo(self.historySizeLabel.snp.centerY)
            maker.width.equalTo(220)
        }
        self.historySizeController.sliderType = .linear
        self.historySizeController.numberOfTickMarks = 3
        self.historySizeController.allowsTickMarkValuesOnly = true

        let dayLabel = Label(fontStyle: .medium, size: 12).withText("Day")
        let weekLabel = Label(fontStyle: .medium, size: 12).withText("Week")
        let monthLabel = Label(fontStyle: .medium, size: 12).withText("Month")

        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.historySizeController.snp.leading).inset(8)
            maker.top.equalTo(self.historySizeController.snp.bottom).inset(-6)
        }

        self.addSubview(weekLabel)
        weekLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.historySizeController.snp.centerX)
            maker.top.equalTo(self.historySizeController.snp.bottom).inset(-6)
        }

        self.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.historySizeController.snp.trailing).inset(8)
            maker.top.equalTo(self.historySizeController.snp.bottom).inset(-6)
        }
    }

    @objc func launchAtLoginToggle() {
        LaunchAtLogin.isEnabled.toggle()
    }

    func updateLaunchButton() {
        self.launchCheckbox.state = LaunchAtLogin.isEnabled ? .on : .off
    }
}
