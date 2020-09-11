//
//  PanelHintView.swift
//  Muna
//
//  Created by Alexander on 9/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import AVKit
import Cocoa

class PanelHintView: PanelPopupView {
    let questionImage = ImageView(name: "icon_question")

    let titleLabel =
        Label(fontStyle: .heavy, size: 16)
            .withTextColorStyle(.hint)
            .withText("Hint")

    let textLabel = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.titleAccent)

    let contentStackView = NSStackView(
        orientation: .vertical,
        alignment: .centerX,
        distribution: .fill
    )

    private let hintItem: HintItem

    init(hintItem: HintItem) {
        self.hintItem = hintItem
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.questionImage)
        self.questionImage.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.closeButton.snp.centerX)
            maker.leading.equalToSuperview().inset(12)
            maker.size.equalTo(20)
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.closeButton.snp.centerX)
            maker.leading.equalTo(self.questionImage.snp.trailing).inset(8)
        }

        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.titleLabel.snp.bottom).inset(14)
            maker.leading.trailing.equalToSuperview().inset(12)
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { maker in
            maker.top.equalTo(self.textLabel.snp.bottom).inset(14)
            maker.leading.trailing.bottom.equalToSuperview().inset(12)
        }

        switch self.hintItem.hint.content {
        case let .multiply(content):
            for item in content {
                self.addHintConent(content: item)
            }
        default:
            self.addHintConent(content: self.hintItem.hint.content)
        }
    }

    private func addHintConent(content: HintContent) {
        switch content {
        case .none:
            break
        case .multiply:
            appAssertionFailure("No such content")
        case let .image(image):
            let imageView = ImageView()
            imageView.image = image
            self.contentStackView.addSubview(imageView)
        case let .shortcut(shortcutItem):
            let shortcutItemView = ShortcutView(item: shortcutItem)
            self.contentStackView.addSubview(shortcutItemView)
        case let .video(name, aspectRatio):
            let videoView = AVPlayerView()
            self.contentStackView.addSubview(videoView)
            videoView.controlsStyle = .none
            videoView.snp.makeConstraints { maker in
                maker.width.equalTo(videoView.snp.height).multipliedBy(aspectRatio)
            }
            if let url = Bundle.main.url(forResource: name, withExtension: "mov") {
                videoView.player = AVPlayer(url: url)
                videoView.player?.play()
            } else {
                appAssertionFailure("No file")
            }
        }
    }
}
