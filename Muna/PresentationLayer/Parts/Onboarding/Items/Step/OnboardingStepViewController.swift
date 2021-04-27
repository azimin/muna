//
//  OnboardingStepViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import AVKit
import Cocoa

class OnboardingStepViewController: NSViewController, OnboardingContainerProtocol {
    enum Style {
        case howToCapture
        case howToRemind
        case howToSeeItems
        case howToGetReminder

        var title: String {
            switch self {
            case .howToCapture:
                return "First step, capture what you need to remember"
            case .howToRemind:
                return "Set your reminder"
            case .howToSeeItems:
                return "Check your reminders"
            case .howToGetReminder:
                return "Receiving a reminder"
            }
        }

        var videoName: String {
            switch self {
            case .howToCapture:
                return "onboarding_part_1"
            case .howToRemind:
                return "onboarding_part_2"
            case .howToSeeItems:
                return "onboarding_part_3"
            case .howToGetReminder:
                return "onboarding_part_4"
            }
        }
    }

    var onNext: VoidBlock?

    private let videoView = AVPlayerView()

    private let titleLabel = Label(fontStyle: .bold, size: 26)
        .withAligment(.left)
        .withTextColorStyle(.titleAccent)

    private let contentView: View

    private let continueButton = OnboardingButton()
        .withText("Next")

    private let style: Style

    init(style: Style) {
        self.style = style

        switch self.style {
        case .howToCapture:
            self.contentView = OnboardingSubviewHowToCapture()
        case .howToRemind:
            self.contentView = OnboardingSubviewHowToRemind()
        case .howToSeeItems:
            self.contentView = OnboardingSubviewHowToSeeItems()
        case .howToGetReminder:
            self.contentView = OnboardingSubviewHowToGetReminder()
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        self.videoView.controlsStyle = .none
        self.videoView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(4)
            maker.width.equalToSuperview()
            maker.width.equalTo(self.videoView.snp.height).multipliedBy(1.45)
        }

        if let url = Bundle.main.url(forResource: self.style.videoName, withExtension: "mp4") {
            self.videoView.player = AVPlayer(url: url)
            self.videoView.player?.play()
        } else {
            appAssertionFailure("No file")
        }

        self.view.addSubview(self.titleLabel)
        self.titleLabel.text = self.style.title
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

        self.continueButton.target = self
        self.continueButton.action = #selector(self.buttonAction(sender:))

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.play),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    @objc func buttonAction(sender: NSButton) {
        self.onNext?()
    }

    @objc func play() {
        self.videoView.player?.seek(to: .zero)
        self.videoView.player?.play()
    }
}
