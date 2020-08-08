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

    let switcher = NSSwitch()

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
        }

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
            make.top.leading.equalToSuperview()
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }

        self.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
