//
//  OnboardingStepViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OnboardingStepViewController: NSViewController, OnboardingContainerProtocol {
    var onNext: VoidBlock?

    let videoView = View()

    let titleLabel = Label(fontStyle: .bold, size: 26)
        .withAligment(.left)
        .withTextColorStyle(.titleAccent)

    let contentView = View()

    let continueButton = OnboardingButton()
        .withText("Next")

    override func loadView() {
        self.view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.view.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 640, height: 660))
        }

        self.view.addSubview(self.videoView)
        self.videoView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(16)
            maker.width.equalToSuperview()
            maker.height.equalTo(self.videoView.snp.width).multipliedBy(1.6)
        }

        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.videoView.snp.bottom).inset(-24)
            maker.leading.equalToSuperview().inset(24)
        }

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { maker in
            maker.top.equalTo(self.titleLabel.snp.bottom).inset(-24)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(24)
            maker.height.equalTo(90)
        }

        self.view.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(24)
            maker.bottom.equalToSuperview().inset(24)
        }
    }
}
