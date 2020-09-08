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

    let introLabel = NSTextField()

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
        imageName: "shortcuts_fullscreen",
        itemUDKey: Preferences.defaultShortcutFullscreenScreenshotKey
    )
    let selectedAreaShortcutPreview = ShortcutPreviewView(
        title: "Capture selected positon shorcut",
        imageName: "shortcuts_selected_area",
        itemUDKey: Preferences.defaultShortcutScreenshotKey
    )
    let showPanelShortuctPreview = ShortcutPreviewView(
        title: "Show captured items shorcut",
        imageName: "shortcuts_panel",
        itemUDKey: Preferences.defaultShortcutPanelKey
    )

    let habitsTitleLabel = Label(fontStyle: .bold, size: 24)
        .withTextColorStyle(.titleAccent)
        .withText("Habits")

    let habitsDescriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("To learn habit of using new app we will remind about it ever time you will use next apps")

    let thingsHabitView = CheckboxWithImageSettingView(image: NSImage(named: "things"), title: "Things", initialState: .on)
    let notesHabitView = CheckboxWithImageSettingView(image: NSImage(named: "notes"), title: "Notes", initialState: .on)
    let remindersHabitView = CheckboxWithImageSettingView(image: NSImage(named: "reminders"), title: "Reminders", initialState: .on)

    let settingsItemView = SettingsItemView(isNeededShowTitle: true, style: .big, needToShake: true)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setupTilte()
        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()

        self.setupTilte()
    }

    private func setupInitialLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 1103, height: 787))
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

        self.addSubview(self.habitsTitleLabel)
        self.habitsTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.shortuctsTilteLabel)
            make.top.equalTo(self.selectedAreaShortcutPreview.snp.bottom).offset(24)
        }

        self.addSubview(self.habitsDescriptionLabel)
        self.habitsDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.shortuctsTilteLabel)
            make.top.equalTo(self.habitsTitleLabel.snp.bottom).offset(24)
        }

        self.addSubview(self.thingsHabitView)
        self.thingsHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self.habitsTitleLabel)
        }

        self.addSubview(self.notesHabitView)
        self.notesHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.trailing.equalTo(self.thingsHabitView.snp.leading).inset(-20)
        }

        self.addSubview(self.remindersHabitView)
        self.remindersHabitView.snp.makeConstraints { make in
            make.top.equalTo(self.habitsDescriptionLabel.snp.bottom).offset(15)
            make.leading.equalTo(self.thingsHabitView.snp.trailing).offset(20)
        }

        self.addSubview(self.settingsItemView)
        self.settingsItemView.snp.makeConstraints { make in
            make.top.equalTo(self.notesHabitView.snp.bottom).offset(20)
            make.leading.equalTo(self.separatorView.snp.trailing).offset(126)
            make.trailing.equalToSuperview().inset(114)
        }

        self.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupTilte() {
        let string = "Setup Muna"
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: FontStyle.customFont(style: .bold, size: 28),
                .foregroundColor: ColorStyle.titleAccent.color,
            ]
        )

        var range = (string as NSString).range(of: "Muna")

        attributedString.addAttributes([.foregroundColor: NSColor(hex: "72AEE4")], range: range)
        range = (string as NSString).range(of: "Setup Muna")

        attributedString.setAlignment(.center, range: range)
        self.introLabel.alignment = .center
        self.introLabel.isBezeled = false
        self.introLabel.isEditable = false
        self.introLabel.backgroundColor = .clear
        self.introLabel.attributedStringValue = attributedString
    }
}
