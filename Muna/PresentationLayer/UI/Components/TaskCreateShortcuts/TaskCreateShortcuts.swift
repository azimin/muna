//
//  TaskCreateShortcuts.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskCreateShortcuts: PopupView {
    enum DescriptionShortcut {
        case createCard
        case nextTextField
        case nextTimeInterval
        case seletTimeInterval

        static var values: [DescriptionShortcut] = [
            .createCard,
            .nextTextField,
            .nextTimeInterval,
            .seletTimeInterval,
        ]

        var shortcut: [TaskCreateView.Shortcuts] {
            switch self {
            case .createCard:
                return [.create]
            case .nextTextField:
                return [.nextField]
            case .nextTimeInterval:
                return [.preveousTime, .nextTime]
            case .seletTimeInterval:
                return [.acceptTime]
            }
        }

        var title: String {
            switch self {
            case .createCard:
                return "Create card"
            case .nextTextField:
                return "Next text field"
            case .nextTimeInterval:
                return "Next time interval"
            case .seletTimeInterval:
                return "Enter time interval"
            }
        }

        var subtitle: String {
            switch self {
            case .createCard:
                return "To immidiatly create new card"
            case .nextTextField:
                return "To go from reminder to comment and back"
            case .nextTimeInterval:
                return "To switch time values when reminder suggest multiply values"
            case .seletTimeInterval:
                return "To select highlited time interval"
            }
        }
    }

    let title = Label(fontStyle: .bold, size: 15)
        .withTextColorStyle(.white)
        .withText("Amazing shortcuts")

    let subtitle = Label(fontStyle: .medium, size: 13)
        .withTextColorStyle(.white60)
        .withText("To 🚀 your productivity")

    let separatorView = View()

    let contentStackView = NSStackView()

    override func setup() {
        super.setup()

        self.snp.makeConstraints { maker in
            maker.width.equalTo(340)
        }

        self.addSubview(self.title)
        self.title.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().inset(16)
        }

        self.addSubview(self.subtitle)
        self.subtitle.snp.makeConstraints { maker in
            maker.top.equalTo(self.title.snp.bottom)
            maker.leading.equalToSuperview().inset(16)
        }

        self.addSubview(self.separatorView)
        self.separatorView.backgroundColor = NSColor.color(.separator)
        self.separatorView.snp.makeConstraints { maker in
            maker.top.equalTo(self.subtitle.snp.bottom).inset(-12)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.spacing = 24
        self.contentStackView.orientation = .vertical
        self.contentStackView.distribution = .fill
        self.contentStackView.snp.makeConstraints { maker in
            maker.top.equalTo(self.separatorView.snp.bottom).inset(-16)
            maker.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        var shortcutViews: [ShortcutDescriptionView] = []
        for item in DescriptionShortcut.values {
            let view = ShortcutDescriptionView(
                title: item.title,
                subtitle: item.subtitle,
                shortcutItems: item.shortcut.map { $0.item }
            )
            self.contentStackView.addArrangedSubview(view)
            shortcutViews.append(view)
        }

        var preveousView: ShortcutDescriptionView?
        for view in shortcutViews {
            view.snp.makeConstraints { maker in
                maker.width.equalToSuperview()
            }

            if let preveousView = preveousView {
                preveousView.shortcutContainerView.snp.makeConstraints { maker in
                    maker.width.equalTo(view.shortcutContainerView.snp.width)
                }
            } else {
                preveousView = view
            }
        }
    }
}
