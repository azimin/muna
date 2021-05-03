//
//  OnboardingAnalyticsView.swift
//  Muna
//
//  Created by Egor Petrov on 07.03.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class OnboardingAnalyticsView: View {

    let analyticsImageView = Button()
        .withImageName(
            "analytics_icon",
            color: .titleAccent
        )

    let titleLabel = Label(fontStyle: .bold, size: 30)
        .withTextColorStyle(.titleAccent)
        .withText("Analytics")
        .withAligment(.center)

    let descriptionLabel = Label(fontStyle: .regular, size: 18)
        .withTextColorStyle(.title60AccentAlpha)
        // swiftlint:disable line_length
        .withText("We use your anonymous usage data to improve our software. We respect your privacy please let us know if you would like to share your data. Thank you!")
        .withAligment(.center)
        .withLimitedNumberOfLines(3)

    let linksLabel = NSTextView()

    let settingsSwitcher = SwitcherSettingsItem(style: .oneLine)

    let countinueButton = OnboardingButton()
        .withText("Done")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        linksLabel.textColor = ColorStyle.title60AccentAlpha.color
        linksLabel.font = .systemFont(ofSize: 18, weight: .regular)
        linksLabel.drawsBackground = false
        linksLabel.isEditable = false
        linksLabel.isSelectable = true
        linksLabel.alignment = .center

        self.setupInitialLayout()
        self.setupLinks()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(527)
        }

        self.addSubview(self.analyticsImageView)
        self.analyticsImageView.isEnabled = false
        self.analyticsImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(71)
            make.height.equalTo(104)
            make.width.equalTo(134)
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.analyticsImageView.snp.bottom).offset(35)
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().inset(100)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }

        self.addSubview(self.linksLabel)
        self.linksLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(327)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(25)
        }

        self.addSubview(self.settingsSwitcher)
        self.settingsSwitcher.titleLabel.text = "Share anonymous usage data"
        self.settingsSwitcher.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().inset(120)
            make.top.equalTo(self.linksLabel.snp.bottom).offset(20)
        }

        self.addSubview(self.countinueButton)
        self.countinueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.settingsSwitcher.snp.bottom).offset(53)
            make.bottom.equalToSuperview().inset(26)
        }
    }

    func setupLinks() {
        let attributedString = NSMutableAttributedString(
            string:
            """
            We use Amplitude for usage data (our events) and App Center for crash reports.
            """,
            attributes: [
                .font: NSFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: ColorStyle.title60AccentAlpha.color
            ]
        )

        attributedString.beginEditing()
        let rangeEvents = (attributedString.string as NSString).range(of: "(our events)")

        attributedString.addAttribute(.link, value: "https://www.notion.so/muna0/Muna-Analytics-66145c7e8d41495bb84d01a3c9b63663", range: rangeEvents)
        attributedString.endEditing()

        self.linksLabel.textStorage?.setAttributedString(attributedString)

        self.linksLabel.snp.makeConstraints { make in
            let height = self.linksLabel.attributedString().calculateHeight(
                forWidth: 327
            )
            make.height.equalTo(height)
        }
    }
}
