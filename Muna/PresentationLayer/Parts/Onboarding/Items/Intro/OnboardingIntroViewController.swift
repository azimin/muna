//
//  OnboardingIntroViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OnboardingIntroViewController: NSViewController, OnboardingContainerProtocol {
    var onNext: VoidBlock?

    let iconImage = ImageView(
        name: "onboarding_icon",
        aspectRation: .resizeAspect
    )

    let introLabel = Label(fontStyle: .bold, size: 30)
        .withTextColorStyle(.titleAccent)
        .withText("Welcome to Muna")
        .withAligment(.center)

    let descriptionLabel = Label(fontStyle: .regular, size: 20)
        .withTextColorStyle(.title60AccentAlpha)
        .withText("Modern way of creating remidners without breaking context")
        .withAligment(.center)

    let betaCode = TextField(clearable: false)

    let continueButton = OnboardingButton()
        .withText("Start")

    override func loadView() {
        self.view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.view.snp.makeConstraints { maker in
            maker.size.equalTo(528)
        }

        self.view.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { maker in
            maker.size.equalTo(124)
            maker.top.equalTo(54)
            maker.centerX.equalToSuperview()
        }

        self.view.addSubview(self.introLabel)
        self.introLabel.snp.makeConstraints { maker in
            maker.width.equalTo(360)
            maker.top.equalTo(self.iconImage.snp.bottom).inset(-32)
            maker.centerX.equalToSuperview()
        }

        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { maker in
            maker.width.equalTo(360)
            maker.top.equalTo(self.introLabel.snp.bottom).inset(-24)
            maker.centerX.equalToSuperview()
        }

        self.view.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(32)
            maker.centerX.equalToSuperview()
        }

        self.view.addSubview(self.betaCode)
        self.betaCode.placeholder = "Beta Key"
        self.betaCode.snp.makeConstraints { make in
            make.bottom.equalTo(self.continueButton.snp.top).inset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
        }
        self.betaCode.isHidden = ServiceLocator.shared.betaKey.isEntered

        self.continueButton.target = self
        self.continueButton.action = #selector(self.buttonAction(sender:))
    }

    @objc func buttonAction(sender: NSButton) {
        let betaKey = self.betaCode.textField.stringValue
        if ServiceLocator.shared.betaKey.isEntered {
            self.onNext?()
        } else if ServiceLocator.shared.betaKey.validate(key: betaKey) {
            ServiceLocator.shared.betaKey.key = betaKey
            self.onNext?()
        } else {
            let alert = NSAlert()
            alert.messageText = "Please enter valid Beta Key"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
