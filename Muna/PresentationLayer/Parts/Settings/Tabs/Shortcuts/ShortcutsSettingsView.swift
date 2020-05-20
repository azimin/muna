//
//  ShortcutsSettingsView.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutsSettingsView: View, SettingsViewProtocol {
    let titlesView = View()
    let settingsView = View()

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
            maker.height.equalTo(500)
        }

        self.addSubview(self.settingsView)
        self.settingsView.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titlesView.snp.trailing)
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(self.frameWidth - 120)
        }
    }
}
