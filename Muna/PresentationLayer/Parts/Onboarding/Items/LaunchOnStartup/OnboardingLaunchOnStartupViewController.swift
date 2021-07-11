//
//  OnboardingLaunchOnStartupViewController.swift
//  Muna
//
//  Created by azimin on 11.07.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class OnboardingLaunchOnStartupViewController: NSViewController, OnboardingContainerProtocol {
    var onNext: VoidBlock?

    let iconImage = ImageView(
        name: "img_launch_on_startup",
        aspectRation: .resizeAspect
    )

    let introLabel = Label(fontStyle: .bold, size: 30)
        .withTextColorStyle(.titleAccent)
        .withText("Launch on startup?")
        .withAligment(.center)

    let descriptionLabel = Label(fontStyle: .regular, size: 20)
        .withTextColorStyle(.title60AccentAlpha)
        .withText("Muna will open automatically upon system restart")
        .withAligment(.center)
    
    let noButton = OnboardingButton(style: .minimal)
        .withText("No")
    
    let yesButton = OnboardingButton()
        .withText("Yes")

    override func loadView() {
        self.view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServiceLocator.shared.analytics.logSetShowNumberOfUncomplitedItems(
            isShow: Preferences.isNeededToShowPassedItems
        )
        
        ServiceLocator.shared.analytics.logLaunchOnStartup(
            shouldLaunch: Preferences.launchOnStartup
        )
        
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
        
        let stackView = NSStackView(orientation: .horizontal, alignment: .centerY, distribution: .fill)

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(32)
            maker.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.noButton)
        stackView.addArrangedSubview(self.yesButton)

        self.yesButton.target = self
        self.yesButton.action = #selector(self.yesButtonAction(sender:))
        
        self.noButton.target = self
        self.noButton.action = #selector(self.noButtonAction(sender:))
    }

    @objc func yesButtonAction(sender: NSButton) {
        Preferences.launchOnStartup = true
        Preferences.isNeededToShowLaunchOnStartup = false
        self.onNext?()
    }
    
    @objc func noButtonAction(sender: NSButton) {
        Preferences.launchOnStartup = false
        Preferences.isNeededToShowLaunchOnStartup = false
        self.onNext?()
    }
}
