//
//  EmptyStateView.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class EmptyStateView: View {
    enum Style {
        case noUncompletedItems(shortcut: ShortcutItem?)
        case noDeadline
        case noCompletedItems
    }

    let stackView = NSStackView()

    let titelLabel = Label(
        fontStyle: .heavy,
        size: 20
    )
    .withAligment(.center)

    let actionLabel = Label(
        fontStyle: .medium,
        size: 14
    )
    .withAligment(.center)

    var shortcutView: NSView?

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.titelLabel.textColor = NSColor.color(.title60AccentAlpha)
        self.actionLabel.textColor = NSColor.color(.title60AccentAlpha)
    }

    private func setup() {
        self.stackView.alignment = .centerX
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.stackView.addArrangedSubview(self.titelLabel)
        self.stackView.setCustomSpacing(14, after: self.titelLabel)
        self.stackView.addArrangedSubview(self.actionLabel)
        self.stackView.setCustomSpacing(8, after: self.actionLabel)
    }

    func update(style: Style) {
        self.shortcutView?.removeFromSuperview()
        self.actionLabel.isHidden = true

        switch style {
        case let .noUncompletedItems(shortcut):
            self.titelLabel.text = "No pending items"
            self.actionLabel.text = "Create first"

            if let shortcut = shortcut {
                self.actionLabel.isHidden = false
                let shortcutView = ShortcutView(item: shortcut)
                self.stackView.addArrangedSubview(shortcutView)

                self.shortcutView = shortcutView
            }
        case .noDeadline:
            self.titelLabel.text = "No items without dealines"
        case .noCompletedItems:
            self.titelLabel.text = "No complited items"
        }
    }
}
