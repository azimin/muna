//
//  SwitcherSwitchItem.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SwitcherSettingsItem: View {
    let titleLabel: Label

    let descriptionLabel: Label

    let switcher = Switcher()

    private let style: SettingsItemView.Style

    init(style: SettingsItemView.Style) {
        let titleSize: CGFloat
        let descriptionSize: CGFloat

        switch style {
        case .big:
            titleSize = 18
            descriptionSize = 16
        case .small:
            titleSize = 14
            descriptionSize = 12
        case .oneLine:
            titleSize = 15
            descriptionSize = .zero
        }

        self.style = style

        self.titleLabel = Label(fontStyle: .bold, size: titleSize)
            .withTextColorStyle(.titleAccent)

        self.descriptionLabel = Label(fontStyle: .medium, size: descriptionSize)
            .withTextColorStyle(.title60Accent)

        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            if self.style == .oneLine {
                make.centerY.leading.equalToSuperview()
            } else {
                make.top.leading.equalToSuperview()
            }
        }

        if self.style != .oneLine {
            self.addSubview(self.descriptionLabel)
            self.descriptionLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            }
        }

        self.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { make in
            if self.style == .oneLine {
                make.bottom.top.equalToSuperview()
            } else {
                make.centerY.equalToSuperview()
            }
            make.trailing.equalToSuperview()
        }
    }
}
