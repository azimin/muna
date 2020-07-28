//
//  OnboardingFinalSetupView.swift
//  Muna
//
//  Created by Egor Petrov on 24.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class OnboardingFinalSetupView: NSView {
    let iconImage = ImageView(
        name: "onboarding_icon",
        aspectRation: .resizeAspect
    )

    let introLabel = Label(fontStyle: .bold, size: 28)
        .withTextColorStyle(.titleAccent)
        .withText("Setup Muna")
        .withAligment(.center)

    let descriptionLabel = Label(fontStyle: .regular, size: 20)
        .withTextColorStyle(.title60AccentAlpha)
        .withText("Modern way of creating remidners without breaking context")
        .withAligment(.center)

    let continueButton = OnboardingButton()
        .withText("Done")

    let separatorView = View()

    let shortuctsTilteLabel = Label(fontStyle: .bold, size: 24)
        .withTextColorStyle(.titleAccent)
        .withText("Shortucts")

    let entireShortcutPreview = ShortcutPreviewView(
        title: "Entire screen capture shortcut",
        imageName: "Fullscreen",
        item: Preferences.DefaultItems.defaultShortcutFullscreenScreenshotShortcut.item
    )
    let selectedAreaShortcutPreview = ShortcutPreviewView(
        title: "Capture selected positon shorcut",
        imageName: "Selected area",
        item: Preferences.DefaultItems.defaultScreenshotShortcut.item
    )
    let showPanelShortuctPreview = ShortcutPreviewView(
        title: "Show captured items shorcut",
        imageName: "Panel",
        item: Preferences.DefaultItems.defaultActivationShortcut.item
    )

    let settingsTitleLabel = Label(fontStyle: .bold, size: 24)
        .withTextColorStyle(.titleAccent)
        .withText("General")

    let startupSettingItem = SwitcherSettingsItem()
    let notificationsSettingItem = SliderSettingsItem()
    let storageSettingItem = SliderSettingsItem()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        let string = "Setup Muna"
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: FontStyle.bold,
                .foregroundColor: NSColor.white,
            ]
        )

        let range = (string as NSString).range(of: "Muna")
        attributedString.addAttributes([.foregroundColor: NSColor(hex: "72AEE4")], range: range)
        self.introLabel.placeholderAttributedString = attributedString

        self.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 1103, height: 676))
        }

        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(104)
            make.top.equalToSuperview().offset(219)
        }

        self.addSubview(self.introLabel)
        self.introLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.iconImage)
            make.top.equalTo(self.iconImage.snp.bottom).offset(22)
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.maximumNumberOfLines = 2
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.iconImage)
            make.top.equalTo(self.introLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.introLabel)
            make.leading.equalToSuperview().offset(40)
        }

        self.addSubview(self.separatorView)
        self.separatorView.backgroundColor = ColorStyle.separator.color
        self.separatorView.snp.makeConstraints { make in
            make.leading.equalTo(self.descriptionLabel.snp.trailing).offset(36)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }

        self.addSubview(self.shortuctsTilteLabel)
        self.shortuctsTilteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(661)
        }

        self.addSubview(self.entireShortcutPreview)
        self.entireShortcutPreview.snp.makeConstraints { make in
            make.top.equalTo(self.shortuctsTilteLabel.snp.bottom).offset(24)
            make.leading.equalTo(self.separatorView.snp.trailing).offset(73)
        }

        self.addSubview(self.selectedAreaShortcutPreview)
        self.selectedAreaShortcutPreview.snp.makeConstraints { make in
            make.top.equalTo(self.shortuctsTilteLabel.snp.bottom).offset(24)
            make.leading.equalTo(self.entireShortcutPreview.snp.trailing).offset(50)
        }

        self.addSubview(self.showPanelShortuctPreview)
        self.showPanelShortuctPreview.snp.makeConstraints { make in
            make.top.equalTo(self.shortuctsTilteLabel.snp.bottom).offset(24)
            make.leading.equalTo(self.selectedAreaShortcutPreview.snp.trailing).offset(50)
            make.trailing.equalToSuperview().inset(73)
        }

        self.addSubview(self.settingsTitleLabel)
        self.settingsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.selectedAreaShortcutPreview.snp.bottom).offset(60)
            make.centerX.equalTo(self.shortuctsTilteLabel)
        }

        self.startupSettingItem.titleLabel.text = "Launch on startup"
        self.startupSettingItem.descriptionLabel.text = "Start Muna automatically after system restart"
        self.addSubview(self.startupSettingItem)
        self.startupSettingItem.snp.makeConstraints { make in
            make.leading.equalTo(self.separatorView.snp.trailing).offset(126)
            make.trailing.equalToSuperview().inset(114)
            make.top.equalTo(self.settingsTitleLabel.snp.bottom).offset(24)
        }

        self.notificationsSettingItem.titleLabel.text = "Ping interval"
        self.notificationsSettingItem.descriptionLabel.text = "Should remind again when you ignore reminder"
        self.notificationsSettingItem.sliderSectionLabel.text = "Month"
        self.addSubview(self.notificationsSettingItem)
        self.notificationsSettingItem.snp.makeConstraints { make in
            make.leading.equalTo(self.separatorView.snp.trailing).offset(126)
            make.trailing.equalToSuperview().inset(114)
            make.top.equalTo(self.startupSettingItem.snp.bottom)
        }

        self.storageSettingItem.titleLabel.text = "History size"
        self.storageSettingItem.descriptionLabel.text = "How long to keep complited items"
        self.storageSettingItem.sliderSectionLabel.text = "Month"
        self.addSubview(self.storageSettingItem)
        self.storageSettingItem.snp.makeConstraints { make in
            make.leading.equalTo(self.separatorView.snp.trailing).offset(126)
            make.trailing.equalToSuperview().inset(114)
            make.top.equalTo(self.notificationsSettingItem.snp.bottom)
        }

        self.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(24)
        }
    }
}
