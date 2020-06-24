//
//  TaskDoneButton.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class PopupButton: Button {
    enum Style {
        case basic
        case distructive
    }

    let overlay = View()

    let label = Label(fontStyle: .semibold, size: 13)
        .withTextColorStyle(.titleAccent)

    private let style: Style

    init(style: Style, title: String) {
        switch style {
        case .basic:
            _ = self.overlay.withBackgroundColorStyle(.lightOverlay)
        case .distructive:
            _ = self.overlay.withBackgroundColorStyle(.distructiveOverlay)
        }

        self.style = style
        super.init(frame: .zero)
        self.setup()

        self.label.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.title = ""

        self.wantsLayer = true
        self.snp.makeConstraints { maker in
            maker.height.equalTo(32)
        }

        self.addSubview(self.overlay)
        self.overlay.layer?.cornerRadius = 6
        self.overlay.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }

        self.addSubview(self.label)
        self.label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
