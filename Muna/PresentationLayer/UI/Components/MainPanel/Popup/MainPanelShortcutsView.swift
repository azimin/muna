//
//  MainPanelShortcutsView.swift
//  Muna
//
//  Created by Egor Petrov on 17.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftDate

class MainPanelShortcutsView: PopupView {
    private var frameWidth: CGFloat = 400

    enum DescriptionShortcut {
        case nextItem
        case nextTab
        case previousSection
        case nextSection
        case deleteItem
        case previewItem
        case complete
        case editTime
        case close
        case makeFullScreenshot
        case makeSelectedAreaShot

        static var values: [DescriptionShortcut] = [
            .nextItem,
            .nextTab,
            .deleteItem,
            .previewItem,
            .complete,
            .editTime,
            .makeFullScreenshot,
            .makeSelectedAreaShot
        ]

        var shortcut: [ViewShortcutProtocol] {
            switch self {
            case .nextItem:
                return [
                    MainScreenViewController.Shortcut.nextItem,
                    MainScreenViewController.Shortcut.preveousItem,
                ]
            case .nextTab:
                return [
                    MainScreenViewController.Shortcut.nextTab,
                    MainScreenViewController.Shortcut.preveousTab,
                ]
            case .nextSection:
                return [MainScreenViewController.Shortcut.nextSection]
            case .previousSection:
                return [MainScreenViewController.Shortcut.preveousSection]
            case .deleteItem:
                return [MainScreenViewController.Shortcut.deleteItem]
            case .previewItem:
                return [MainScreenViewController.Shortcut.previewItem]
            case .complete:
                return [MainScreenViewController.Shortcut.complete]
            case .editTime:
                return [MainScreenViewController.Shortcut.editTime]
            case .close:
                return [MainScreenViewController.Shortcut.close]
            case .makeFullScreenshot:
                return [Preferences.DefaultItems.defaultShortcutFullscreenScreenshotShortcut]
            case .makeSelectedAreaShot:
                return [Preferences.DefaultItems.defaultScreenshotShortcut]
            }
        }

        var title: String {
            switch self {
            case .nextItem:
                return "Next/Previous reminder"
            case .nextTab:
                return "Next/Previous tab"
            case .nextSection:
                return "Next section"
            case .previousSection:
                return "Previous section"
            case .deleteItem:
                return "Delete reminder"
            case .previewItem:
                return "Show preview of your reminder"
            case .complete:
                return "Mark as completed"
            case .editTime:
                return "Edit due date"
            case .close:
                return "Show/Close reminder panel"
            case .makeFullScreenshot:
                return "Capture a written note"
            case .makeSelectedAreaShot:
                return "Capture visual note"
            }
        }

        var subtitle: String {
            switch self {
            case .nextItem:
                return "Select the reminder to edit"
            case .nextTab:
                return "Pending, no due date, completed"
            case .nextSection:
                return "Show the next sections"
            case .previousSection:
                return "Show the previous sections"
            case .deleteItem:
                return ""
            case .previewItem:
                return "Show a large preview of the reminder"
            case .complete:
                return "Mark a reminder as completed"
            case .editTime:
                return "Edit your due date if you need more time"
            case .close:
                return ""
            case .makeFullScreenshot:
                return ""
            case .makeSelectedAreaShot:
                return ""
            }
        }
    }

    let title = Label(fontStyle: .bold, size: 15)
        .withTextColorStyle(.titleAccent)
        .withText("Amazing shortcuts")

    let subtitle = Label(fontStyle: .medium, size: 13)
        .withTextColorStyle(.title60Accent)
        .withText("To 🚀 your productivity")

    let separatorView = View()

    let contentStackView = NSStackView()

    override func setup(forStyle style: Style) {
        super.setup(forStyle: style)

        self.snp.makeConstraints { maker in
            maker.width.equalTo(self.frameWidth)
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
            maker.height.equalTo(1)
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.spacing = 24
        self.contentStackView.orientation = .vertical
        self.contentStackView.alignment = .leading
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
