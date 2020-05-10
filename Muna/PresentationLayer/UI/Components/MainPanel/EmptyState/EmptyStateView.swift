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
        case noUncompletedItems(shortcut: String?)
        case noDeadline
        case noCompletedItems
    }

    let titelLabel = Label(
        fontStyle: .heavy,
        size: 20
    )
    .withAligment(.center)

    let actionLabel = Label(
        fontStyle: .medium,
        size: 14
    )
    .withTextColorStyle(.white60alpha)
    .withAligment(.center)

    let shortcutLabel = Label(
        fontStyle: .medium,
        size: 14
    )
    .withTextColorStyle(.white60alpha)
    .withAligment(.center)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stackView = NSStackView()
        stackView.alignment = .centerX
        self.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        stackView.addArrangedSubview(self.titelLabel)
        stackView.setCustomSpacing(14, after: self.titelLabel)
        stackView.addArrangedSubview(self.actionLabel)
        stackView.setCustomSpacing(8, after: self.actionLabel)
        stackView.addArrangedSubview(self.shortcutLabel)
    }

    func update(style: Style) {
        self.shortcutLabel.isHidden = true
        self.actionLabel.isHidden = true

        switch style {
        case let .noUncompletedItems(shortcut):
            self.titelLabel.text = "No pending items"
            self.actionLabel.text = "Create first"

            if let shortcut = shortcut {
                self.actionLabel.isHidden = false
                self.shortcutLabel.isHidden = false
                self.shortcutLabel.text = shortcut
            }
        case .noDeadline:
            self.titelLabel.text = "No items without dealines"
        case .noCompletedItems:
            self.titelLabel.text = "No complited items"
        }
    }
}
