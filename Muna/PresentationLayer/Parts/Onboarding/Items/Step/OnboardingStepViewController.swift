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
                return "Capture important context"
            case .howToRemind:
                return "Ask to remind"
            case .howToSeeItems:
                return "Check items"
            case .howToGetReminder:
                return "Get reminder"
            }
        }
    }

    var onNext: VoidBlock?

    private let videoView = AVPlayerView()

    private let titleLabel = Label(fontStyle: .bold, size: 26)
        .withAligment(.left)
        .withTextColorStyle(.titleAccent)

    private let contentView = View()

    private let continueButton = OnboardingButton()
        .withText("Next")

    private let style: Style

    init(style: Style) {
        self.style = style
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
            maker.top.equalToSuperview().inset(16)
            maker.width.equalToSuperview()
            maker.width.equalTo(self.videoView.snp.height).multipliedBy(1.6)
        }

        if let url = Bundle.main.url(forResource: "onboarding_part_1", withExtension: "mov") {
            self.videoView.player = AVPlayer(url: url)
            self.videoView.player?.play()
        } else {
            assertionFailure("No file")
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
