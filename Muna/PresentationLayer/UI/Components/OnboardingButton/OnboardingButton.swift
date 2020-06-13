//
//  OnboardingButton.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OnboardingButton: Button {
    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.snp.makeConstraints { maker in
            maker.height.equalTo(38)
            maker.width.greaterThanOrEqualTo(150)
        }

        self.wantsLayer = true
        self.layer?.backgroundColor = CGColor.color(.blueSelected)
        self.layer?.cornerRadius = 8

        self.font = FontStyle.customFont(style: .bold, size: 16)

        _ = self.withTextColorStyle(.titleAccent)
    }
}
