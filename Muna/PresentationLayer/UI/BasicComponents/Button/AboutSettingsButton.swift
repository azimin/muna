//
//  AboutSettingsButton.swift
//  Muna
//
//  Created by Egor Petrov on 18.02.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class AboutSettingsButton: Button {
    let overlay = View()
        .withBackgroundColorStyle(.lightOverlay)

    let label = Label(fontStyle: .medium, size: 14)
        .withTextColorStyle(.titleAccent)

    init(title: String) {
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

        self.addSubview(self.overlay)
        self.overlay.layer?.cornerRadius = 8
        self.overlay.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.addSubview(self.label)
        self.label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}
