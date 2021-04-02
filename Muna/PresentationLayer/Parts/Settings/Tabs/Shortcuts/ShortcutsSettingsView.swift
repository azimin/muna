//
//  ShortcutsSettingsView.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutsSettingsView: View, SettingsViewProtocol {
    let entireShortcutPreview = ShortcutPreviewView(
        title: "Capture text note shortcut",
        imageName: "shortcuts_fullscreen",
        itemUDKey: Preferences.defaultShortcutTextTaskKey
    )

    let selectedAreaShortcutPreview = ShortcutPreviewView(
        title: "Capture selected positon shorcut",
        imageName: "shortcuts_selected_area",
        itemUDKey: Preferences.defaultShortcutVisualTaskKey
    )

    let showPanelShortuctPreview = ShortcutPreviewView(
        title: "Show captured items shorcut",
        imageName: "shortcuts_panel",
        itemUDKey: Preferences.defaultShortcutPanelKey
    )

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(self.frameWidth)
            make.height.equalTo(260)
        }

        self.addSubview(self.entireShortcutPreview)
        self.entireShortcutPreview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(40)
        }

        self.addSubview(self.selectedAreaShortcutPreview)
        self.selectedAreaShortcutPreview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }

        self.addSubview(self.showPanelShortuctPreview)
        self.showPanelShortuctPreview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(40)
        }
    }
}
