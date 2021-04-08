//
//  TipsSettingsView.swift
//  Muna
//
//  Created by Alexander on 3/30/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class TipsSettingsView: View, SettingsViewProtocol {
    enum State {
        case normal
        case thankYou
    }

    let iconImage = ImageView(
        name: "onboarding_icon",
        aspectRation: .resizeAspect
    )

    let introLabel = Label(fontStyle: .bold, size: 28)
        .withTextColorStyle(.titleAccent)
        .withAligment(.center)

    let descriptionLabel = Label(fontStyle: .regular, size: 18)
        .withTextColorStyle(.title60AccentAlpha)
        .withAligment(.center)

    let oneTimePurchase = TipPurchaseButton(style: .normal)
    let subscriptionPurchase = TipPurchaseButton(style: .accent)

    let privacyView = PrivacyView()

    init() {
        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
    }

    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(self.frameWidth)
        }

        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.size.equalTo(84)
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
        }

        self.addSubview(self.introLabel)
        self.introLabel.snp.makeConstraints { make in
            make.width.equalTo(360)
            make.top.equalTo(self.iconImage.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28)
            make.top.equalTo(self.introLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        }

        let buttonsStackView = NSStackView(
            orientation: .horizontal,
            alignment: .centerY,
            distribution: .fill
        )
        buttonsStackView.spacing = 16
        buttonsStackView.addArrangedSubview(self.oneTimePurchase)
        buttonsStackView.addArrangedSubview(self.subscriptionPurchase)

        self.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        }

        self.addSubview(self.privacyView)
        self.privacyView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }

        self.oneTimePurchase.titleLabel.text = "One Time Tip"
        self.oneTimePurchase.subtitleLabel.text = "$5"

        self.subscriptionPurchase.titleLabel.text = "Monthly"
        self.subscriptionPurchase.subtitleLabel.text = "$1 / month"

        self.oneTimePurchase.target = self
        self.oneTimePurchase.action = #selector(self.oneTimePurchaseAction)

        self.subscriptionPurchase.target = self
        self.subscriptionPurchase.action = #selector(self.subscriptionPurchaseAction)

        self.updateState(state: .normal)
    }

    func updateState(state: State) {
        switch state {
        case .normal:
            self.introLabel.text = "Support Muna"
            self.descriptionLabel.text = "If you like idea of Muna, and would like to support future deveopment, please leave us some tips."
        case .thankYou:
            self.introLabel.text = "Thank you ❤️"
            self.descriptionLabel.text = "We really appreciate your help"
        }
    }

    func updatePurchaseButton() {
        ServiceLocator.shared.inAppPurchaseManager
    }

    func playPurchaseAnimation() {
        print("Play purchase animation")
    }

    @objc
    func oneTimePurchaseAction() {
//        ServiceLocator.shared.inAppPurchaseManager.buyProduct(.oneTimeTip)
        self.updateState(state: .thankYou)
        self.playPurchaseAnimation()
    }

    @objc
    func subscriptionPurchaseAction() {
//        ServiceLocator.shared.inAppPurchaseManager.buyProduct(.monthly)
        self.updateState(state: .thankYou)
        self.playPurchaseAnimation()
    }
}
