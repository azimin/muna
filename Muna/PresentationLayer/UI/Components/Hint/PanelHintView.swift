//
//  PanelHintView.swift
//  Muna
//
//  Created by Alexander on 9/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import AVKit
import Cocoa

enum AssistentItem {
    case popularItem(item: ItemModel)
    case usageHint(hint: Hint)
    case shortcutOfTheDay(shortcut: ShortcutItem)

    var name: String {
        switch self {
        case .popularItem:
            return "Popular Item"
        case .shortcutOfTheDay:
            return "Shortcut of the day"
        case .usageHint:
            return "Usage Hint"
        }
    }

    var nameColor: NSColor {
        switch self {
        case .popularItem:
            return NSColor(hex: "8EF075")
        case .shortcutOfTheDay:
            return NSColor(hex: "7DBBFF")
        case .usageHint:
            return NSColor(hex: "FFE37D")
        }
    }

    var title: String? {
        switch self {
        case let .popularItem(item):
            return "You moved this item \(item.numberOfTimeChanges ?? 0) times"
        case .shortcutOfTheDay:
            return nil
        case let .usageHint(hint):
            return hint.text
        }
    }
}

class AssistentItemView: View {
    let closeButton = Button()
        .withImageName("icon_close", color: .title60Accent)

    let titleLabel =
        Label(fontStyle: .heavy, size: 16)
            .withTextColorStyle(.hint)
            .withText("Hint")

    let contentStackView = NSStackView(
        orientation: .vertical,
        alignment: .centerX,
        distribution: .fill
    )

    private let hintItem: HintItem

    init(hintItem: HintItem) {
        self.hintItem = hintItem
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
//        self.addSubview(self.questionImage)
//        self.questionImage.snp.makeConstraints { maker in
//            maker.centerY.equalTo(self.closeButton.snp.centerY)
//            maker.leading.equalToSuperview().inset(12)
//            maker.size.equalTo(20)
//        }
//
//        self.addSubview(self.titleLabel)
//        self.titleLabel.snp.makeConstraints { maker in
//            maker.centerY.equalTo(self.closeButton.snp.centerY)
//            maker.leading.equalTo(self.questionImage.snp.trailing).inset(-8)
//        }
//
//        self.addSubview(self.textLabel)
//        self.textLabel.text = self.hintItem.hint.text
//        self.textLabel.snp.makeConstraints { maker in
//            maker.top.equalTo(self.titleLabel.snp.bottom).inset(-14)
//            maker.leading.trailing.equalToSuperview().inset(12)
//        }
//
//        self.addSubview(self.contentStackView)
//        self.contentStackView.snp.makeConstraints { maker in
//            maker.top.equalTo(self.textLabel.snp.bottom).inset(-14)
//            maker.leading.trailing.bottom.equalToSuperview().inset(12)
//        }

        switch self.hintItem.hint.content {
        case let .multiply(content):
            for item in content {
                self.addHintConent(content: item)
            }
        default:
            self.addHintConent(content: self.hintItem.hint.content)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.play),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    var videoPlayer: AVPlayerView?

    private func addHintConent(content: HintContent) {
        switch content {
        case .none:
            break
        case .multiply:
            appAssertionFailure("No such content")
        case let .image(image):
            let imageView = ImageView()
            imageView.image = image
            self.contentStackView.addArrangedSubview(imageView)
        case let .shortcut(shortcutItem):
            let shortcutItemView = ShortcutView(item: shortcutItem)
            self.contentStackView.addArrangedSubview(shortcutItemView)
        case let .video(name, aspectRatio):
            let videoView = AVPlayerView()
            self.contentStackView.addArrangedSubview(videoView)
            videoView.controlsStyle = .none
            videoView.snp.makeConstraints { maker in
                maker.width.equalToSuperview()
                maker.width.equalTo(videoView.snp.height).multipliedBy(aspectRatio)
            }
            if let url = Bundle.main.url(forResource: name, withExtension: "mov") {
                videoView.player = AVPlayer(url: url)
                videoView.player?.play()
            } else {
                appAssertionFailure("No file")
            }

            if self.videoPlayer != nil {
                appAssertionFailure("Don't support > 1 video")
            }

            self.videoPlayer = videoView
        }
    }

    @objc func play() {
        self.videoPlayer?.player?.seek(to: .zero)
        self.videoPlayer?.player?.play()
    }
}
