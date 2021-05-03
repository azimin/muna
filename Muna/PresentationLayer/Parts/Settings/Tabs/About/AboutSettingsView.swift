//
//  AboutSettingsView.swift
//  Muna
//
//  Created by Alexander on 8/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class AboutSettingsView: View, SettingsViewProtocol {
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

    let developersLabel = NSTextView()

    let separatorView = View()

    let visitSiteButton = AboutSettingsButton(title: "Visit Website")

    let getHelpButton = AboutSettingsButton(title: "Get Help")

    let acknowledgementsButton = AboutSettingsButton(title: "Acknowledgements")

    init() {
        super.init(frame: .zero)

        self.separatorView.backgroundColor = ColorStyle.separator.color

        self.setup()
        self.setupLinks()
        if let dictionary = Bundle.main.infoDictionary,
           let version = dictionary["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Version \(version)"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()

        developersLabel.textColor = ColorStyle.title60AccentAlpha.color
        developersLabel.font = .systemFont(ofSize: 14, weight: .medium)
        developersLabel.drawsBackground = false
        developersLabel.linkTextAttributes =
            [
                .font: NSFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: ColorStyle.title60AccentAlpha.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: ColorStyle.title60AccentAlpha.color,
                .cursor: NSCursor.pointingHand
            ]
        developersLabel.isEditable = false
        developersLabel.isSelectable = true

        self.setupLinks()
    }

    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(self.frameWidth)
            make.height.equalTo(260)
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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
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
            make.leading.equalToSuperview().inset(-3)
            make.top.equalTo(self.versionLabel.snp.bottom).offset(6)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(85)
            make.bottom.equalToSuperview()
        }

        containerView.addSubview(textContainerView)
        textContainerView.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageView.snp.trailing).inset(-12)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(self.separatorView.snp.top).inset(-22)
            make.centerX.equalToSuperview()
            make.width.equalTo(392)
        }

        self.visitSiteButton.target = self
        self.visitSiteButton.action = #selector(self.visitWebpage)

        self.getHelpButton.target = self
        self.getHelpButton.action = #selector(self.getHelp)

        self.acknowledgementsButton.target = self
        self.acknowledgementsButton.action = #selector(self.visitAcknowledgement)
    }

    @objc
    func visitWebpage() {
        let url = URL(string: "https://muna.live")!
        NSWorkspace.shared.open(url)
    }

    @objc
    func getHelp() {
        let url = URL(string: "https://muna.live")!
        NSWorkspace.shared.open(url)
    }

    @objc
    func visitAcknowledgement() {
        let url = URL(string: "https://muna.live/acknowledgement")!
        NSWorkspace.shared.open(url)
    }

    func setupLinks() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4

        let attributedString = NSMutableAttributedString(
            string:
            """
            With 💜 from Alexander and Egor
            Icon from Denis
            Site designed by Alex L., built by Ilya
            """,
            attributes: [
                .font: NSFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: ColorStyle.title60AccentAlpha.color,
                .paragraphStyle: style
            ]
        )

        attributedString.beginEditing()
        let rangeOfAlexander = (attributedString.string as NSString).range(of: "Alexander")
        let rangeOfEgor = (attributedString.string as NSString).range(of: "Egor")
        let rangeOfDenis = (attributedString.string as NSString).range(of: "Denis")
        let rangeOfAlex = (attributedString.string as NSString).range(of: "Alex L.")
        let rangeOfIlya = (attributedString.string as NSString).range(of: "Ilya")

        attributedString.addAttribute(.link, value: "https://github.com/azimin", range: rangeOfAlexander)
        attributedString.addAttribute(.link, value: "https://github.com/barbatosso", range: rangeOfEgor)
        attributedString.addAttribute(.link, value: "https://denis_ozdemir.dribbble.com", range: rangeOfDenis)
        attributedString.addAttribute(.link, value: "https://dribbble.com/Lafaki", range: rangeOfAlex)
        attributedString.addAttribute(.link, value: "https://github.com/ilyamilosevic", range: rangeOfIlya)
        
        attributedString.endEditing()

        self.developersLabel.textStorage?.setAttributedString(attributedString)
    }
}
