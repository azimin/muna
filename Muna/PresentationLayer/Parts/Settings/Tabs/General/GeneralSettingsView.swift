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
    let settingsItemView = SettingsItemView(isNeededShowTitle: false, style: .small, needToShake: false)

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
            maker.height.equalTo(300)
        }

        self.addSubview(self.settingsItemView)
        self.settingsItemView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            make.width.equalTo(self.frameWidth)
        }
    }

    @objc func launchAtLoginToggle() {
        LaunchAtLogin.isEnabled.toggle()
    }

    func updateLaunchButton() {
//        self.launchCheckbox.state = LaunchAtLogin.isEnabled ? .on : .off
    }
}
