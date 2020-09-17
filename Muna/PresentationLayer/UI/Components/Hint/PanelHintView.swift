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
    case usageHint(hintItem: HintItem)
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
        case let .usageHint(hintItem):
            return hintItem.hint.text
        }
    }

    var description: String? {
        switch self {
        case .popularItem:
            return "We suggest to complete it or think about better deadline"
        case .shortcutOfTheDay, .usageHint:
            return nil
        }
    }
}

class AssistentItemView: View {
    let closeButton = Button()
        .withImageName("icon_close", color: .title60Accent)

    let backgroundView = View()
        .withBackgroundColorStyle(.lightForegroundOverlay)

    let titleLabel =
        Label(fontStyle: .heavy, size: 16)
            .withTextColorStyle(.hint)
            .withText("Hint")

    let contentStackView = NSStackView(
        orientation: .vertical,
        alignment: .leading,
        distribution: .fill
    )

    private let assistentItem: AssistentItem

    init(assistentItem: AssistentItem) {
        self.assistentItem = assistentItem
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 0,
                bottom: 0,
                right: 12
            ))
            make.size.equalTo(CGSize(width: 16, height: 16))
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.text = self.assistentItem.name
        self.titleLabel.textColor = self.assistentItem.nameColor
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.closeButton.snp.centerY)
            make.leading.equalToSuperview().inset(12)
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-14)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }

        if let title = self.assistentItem.title {
            let titleLabel = Label(fontStyle: .medium, size: 14)
                .withTextColorStyle(.titleAccent)
                .withText(title)
            self.contentStackView.addArrangedSubview(titleLabel)
        }

        if let description = self.assistentItem.description {
            let descriptionLabel = Label(fontStyle: .medium, size: 14)
                .withTextColorStyle(.title60Accent)
                .withText(description)
            self.contentStackView.addArrangedSubview(descriptionLabel)
        }

        switch self.assistentItem {
        case let .usageHint(hintItem):
            self.setupWithHint(hintItem: hintItem)
        case let .shortcutOfTheDay(shortcut):
            let shortcutView = ShortcutView(item: shortcut)
            self.contentStackView.addArrangedSubview(shortcutView)
        case let .popularItem(item):
            let itemView = MainPanelItemView()
            itemView.update(item: item, style: .basic)

            let scale: CGFloat = 0.8
            let widthPaggination = (self.frame.width * (1 - scale)) / 2
            let heightPaggination = (self.frame.height * (1 - scale)) / 2
            let transform = CATransform3DConcat(CATransform3DMakeScale(scale, scale, 1), CATransform3DMakeTranslation(widthPaggination, heightPaggination, 0))
            itemView.layer?.transform = transform
            self.contentStackView.addArrangedSubview(itemView)
        }
    }

    func setupWithHint(hintItem: HintItem) {
        switch hintItem.hint.content {
        case let .multiply(content):
            for item in content {
                self.addHintConent(content: item)
            }
        default:
            self.addHintConent(content: hintItem.hint.content)
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
