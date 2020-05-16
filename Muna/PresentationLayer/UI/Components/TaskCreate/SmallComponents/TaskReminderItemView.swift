//
//  TaskReminderItemView.swift
//  Muna
//
//  Created by Alexander on 5/12/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SnapKit

class TaskReminderItemView: View {
    enum Style {
        case basic
        case selected
        case notSelected
    }

    var contentViewConstraint: Constraint?

    let selectionView = View()
    let contentView = View()
    let iconImageView = ImageView()
    let mainLabel = Label(fontStyle: .bold, size: 12)
    let infoLabel = Label(fontStyle: .bold, size: 12)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.mainLabel.text = "No reminder"
        self.infoLabel.text = "in 2 days"

        self.addSubview(self.selectionView)
        self.selectionView.layer?.cornerRadius = 4
        self.selectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { maker in
            self.contentViewConstraint = maker.edges.equalToSuperview().constraint
        }

        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.size.equalTo(CGSize(width: 14, height: 15))
            maker.centerY.equalToSuperview()
        }

        self.contentView.addSubview(self.mainLabel)
        self.mainLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.iconImageView.snp.trailing).inset(-6)
            maker.top.equalToSuperview().inset(6)
            maker.bottom.equalToSuperview().inset(6)
        }

        self.contentView.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.leading.greaterThanOrEqualTo(self.mainLabel.snp.trailing).inset(-8)
            maker.centerY.equalToSuperview()
        }

        self.update(style: .basic)
    }

    func update(item: RemindersOptionsController.ReminderItem) {
        self.mainLabel.text = item.title
        self.infoLabel.text = item.subtitle
    }

    func update(style: Style, animated: Bool = false) {
        self.selectionView.backgroundColor = NSColor.color(.clear)
        self.mainLabel.textColor = NSColor.color(.titleAccent)
        self.infoLabel.textColor = NSColor.color(.titleAccent).withAlphaComponent(0.8)

        switch style {
        case .basic:
            self.iconImageView.image = NSImage(named: NSImage.Name("icon_remind"))?.tint(color: .color(.blueSelected))
            self.mainLabel.textColor = NSColor.color(.blueSelected)
        case .selected:
            self.iconImageView.image = NSImage(named: NSImage.Name("icon_remind"))?.tint(color: .color(.titleAccent))
            self.selectionView.backgroundColor = NSColor.color(.blueSelected)
        case .notSelected:
            self.iconImageView.image = NSImage(named: NSImage.Name("icon_remind"))?.tint(color: NSColor.color(.titleAccent))
        }

        self.updateConstraints(style: style, animated: animated)
    }

    func updateConstraints(style: Style, animated: Bool) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animated ? 0.25 : 0
            context.allowsImplicitAnimation = true

            switch style {
            case .basic:
                self.contentViewConstraint?.update(inset: NSEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0
                ))
            case .selected, .notSelected:
                self.contentViewConstraint?.update(inset: NSEdgeInsets(
                    top: 0,
                    left: 8,
                    bottom: 0,
                    right: 8
                ))
            }

            self.layoutSubtreeIfNeeded()

        }, completionHandler: nil)
    }
}
