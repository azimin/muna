//
//  AboutSettingsView.swift
//  Muna
//
//  Created by Alexander on 8/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class AboutSettingsView: View, SettingsViewProtocol {
    let titlesView = View()
    let settingsView = View()

    let iconImageView = ImageView(
        name: "onboarding_icon",
        aspectRation: .resizeAspect
    )

    let titleLabel = Label(fontStyle: .bold, size: 22)
        .withTextColorStyle(.titleAccent)
        .withText("Muna")

    let versionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.titleAccent)
        .withText("Version 1.7.0")

    let developersLabel = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.title60AccentAlpha)
        .withLimitedNumberOfLines(2)
        .withText(
            """
            With 💜 from Alex and Egor
            Icon from Denis
            """
        )

    let separatorView = View()

    let visitSiteButton = AboutSettingsButton(title: "Visit Website")

    let getHelpButton = AboutSettingsButton(title: "Get Help")

    let acknowledgementsButton = AboutSettingsButton(title: "Acknowledgements")

    init() {
        super.init(frame: .zero)

        self.separatorView.backgroundColor = ColorStyle.separator.color

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
            maker.height.equalTo(260)
        }

        self.addSubview(self.settingsView)
        self.settingsView.snp.makeConstraints { maker in
            maker.leading.equalTo(self.titlesView.snp.trailing)
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(self.frameWidth - 120)
        }

        self.addSubview(self.visitSiteButton)
        self.visitSiteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(118)
            make.height.equalTo(32)
        }

        self.addSubview(self.getHelpButton)
        self.getHelpButton.snp.makeConstraints { make in
            make.leading.equalTo(self.visitSiteButton.snp.trailing).offset(16)
            make.centerY.equalTo(self.visitSiteButton)
            make.width.equalTo(99)
            make.height.equalTo(32)
        }

        self.addSubview(self.acknowledgementsButton)
        self.acknowledgementsButton.snp.makeConstraints { make in
            make.leading.equalTo(self.getHelpButton.snp.trailing).offset(16)
            make.centerY.equalTo(self.visitSiteButton)
            make.width.equalTo(167)
            make.height.equalTo(32)
        }

        self.addSubview(self.separatorView)
        self.separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.visitSiteButton.snp.top).inset(-14)
        }

        let containerView = View()
        containerView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(104)
        }

        let textContainerView = View()
        textContainerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }

        textContainerView.addSubview(self.versionLabel)
        self.versionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.trailing.lessThanOrEqualToSuperview()
        }

        textContainerView.addSubview(self.developersLabel)
        self.developersLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.versionLabel.snp.bottom).offset(6)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }

        containerView.addSubview(textContainerView)
        textContainerView.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageView.snp.trailing)
            make.centerY.equalTo(self.iconImageView)
            make.trailing.equalToSuperview()
        }

        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(self.separatorView.snp.top).inset(-43)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
    }
}
