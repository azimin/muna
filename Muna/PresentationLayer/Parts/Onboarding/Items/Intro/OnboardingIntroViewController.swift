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

        self.continueButton.target = self
        self.continueButton.action = #selector(self.next)
    }

    @objc
    func next() {
        self.onNext?()
    }
}
