//
//  TipsSettingsView.swift
//  Muna
//
//  Created by Alexander on 3/30/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class TipsSettingsView: View, SettingsViewProtocol {
    var topViewController: SettingsViewController?

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

    let cancelSubscriptionInfoView = CancelSubscriptionView()
    let privacyView = PrivacyView()

    let flyingEmojiView = FlyEmojiView()

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

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        self.updatePurchaseButton()
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

        let infoStackView = NSStackView(
            orientation: .vertical,
            alignment: .centerX,
            distribution: .fill
        )

        self.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsStackView.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }

        infoStackView.addArrangedSubview(self.cancelSubscriptionInfoView)
        infoStackView.addArrangedSubview(self.privacyView)

        self.addSubview(self.flyingEmojiView)
        self.flyingEmojiView.allowedTouchTypes = []
        self.flyingEmojiView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.oneTimePurchase.titleLabel.text = "One time donation"
        self.oneTimePurchase.subtitleLabel.text = "$5"

        self.subscriptionPurchase.titleLabel.text = "Monthly donation"
        self.subscriptionPurchase.subtitleLabel.text = "$1 / month"

        self.oneTimePurchase.target = self
        self.oneTimePurchase.action = #selector(self.oneTimePurchaseAction)

        self.subscriptionPurchase.target = self
        self.subscriptionPurchase.action = #selector(self.subscriptionPurchaseAction)

        self.cancelSubscriptionInfoView.howButton.target = self
        self.cancelSubscriptionInfoView.howButton.action = #selector(self.howToUnsubscribe)

        self.privacyView.restoreButton.target = self
        self.privacyView.restoreButton.action = #selector(self.restoreAction)

        self.updateState(state: .normal, shouldUpdateFrame: true)
        self.updatePurchaseButton(subscribed: false)
    }

    func updateState(state: State, shouldUpdateFrame: Bool = true) {
        switch state {
        case .normal:
            self.introLabel.text = "Support Muna"
            self.descriptionLabel.text = "If you like the idea of Muna and would like to support future development, please donate."
        case .thankYou:
            self.introLabel.text = "Thank you ❤️"
            self.descriptionLabel.text = "We really appreciate your support"
        }

        if shouldUpdateFrame {
            self.topViewController?.updateFrame(animate: true)
        }
    }

    func updatePurchaseButton() {
        let isUserPro = ServiceLocator.shared.securityStorage.getBool(forKey: SecurityStorage.Key.isUserPro.rawValue) ?? false
        self.updatePurchaseButton(subscribed: isUserPro)
        
        ServiceLocator.shared.inAppPurchaseManager.validateSubscription { _ in
            let isUserPro = ServiceLocator.shared.securityStorage.getBool(forKey: SecurityStorage.Key.isUserPro.rawValue) ?? false
            self.updatePurchaseButton(subscribed: isUserPro)
        }
    }

    func updatePurchaseButton(subscribed: Bool) {
        if subscribed {
            self.updateState(state: .thankYou)
            self.subscriptionPurchase.titleLabel.text = "Already Subscribed"
        } else {
            self.subscriptionPurchase.titleLabel.text = "Monthly donation"
        }

        self.subscriptionPurchase.isEnabled = !subscribed
        self.cancelSubscriptionInfoView.isHidden = !subscribed
    }

    func playPurchaseAnimation() {
        self.flyingEmojiView.runAnimation()
    }

    @objc
    func restoreAction() {
        ServiceLocator.shared.inAppPurchaseManager.restorePurchases { _ in
            self.updatePurchaseButton()
        }
    }

    @objc
    func howToUnsubscribe() {
        let url = URL(string: "https://support.apple.com/en-gb/HT202039")!
        NSWorkspace.shared.open(url)
    }

    @objc
    func oneTimePurchaseAction() {
        ServiceLocator.shared.inAppPurchaseManager.buyProduct(.oneTimeTip) { status in
            switch status {
            case .purchased:
                self.updateState(state: .thankYou)
                self.playPurchaseAnimation()
            case .cancelled:
                break
            case .error:
                ServiceLocator.shared.windowManager.showAlert(
                    title: "Oops, something went wrong!",
                    text: "We are sorry, but we can't process your payment now 😢"
                )
            }
        }
    }

    @objc
    func subscriptionPurchaseAction() {
        ServiceLocator.shared.inAppPurchaseManager.buyProduct(.monthly) { (status) in
            DispatchQueue.main.async {
                switch status {
                case .purchased:
                    self.updateState(state: .thankYou)
                    self.playPurchaseAnimation()
                    self.updatePurchaseButton(subscribed: true)
                case .cancelled:
                    break
                case .error:
                    ServiceLocator.shared.windowManager.showAlert(
                        title: "Oops, something went wrong!",
                        text: "We are sorry, but we can't process your payment now 😢"
                    )
                }
            }
        }
    }
}
