//
//  OnboardingSubviewHowToGetReminder.swift
//  Muna
//
//  Created by Alexander on 6/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class OnboardingSubviewHowToGetReminder: View {
    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("""
        If you ignore reminder, system will ping you some time later
        You can change time of reminder with language structure or smart recommendations
        """)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
    }
}
