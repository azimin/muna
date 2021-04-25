//
//  OnboardingSubviewHowToRemind.swift
//  Muna
//
//  Created by Alexander on 6/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class OnboardingSubviewHowToRemind: View {
    let titleLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)
        .withText("You can use any of these phrases or set a date and time")

    let contentStackView = NSStackView(orientation: .vertical, alignment: .leading)

    var timeExamples: [String] = [
        "in 2h",
        "tomorrow",
        "in the evening",
        "2 pm",
        "next monday 10 am",
        "weekends",
        "15 min",
        "in 3 days in the morning",
    ]

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview()
        }

        self.contentStackView.spacing = 24
        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { maker in
            maker.top.equalTo(self.titleLabel.snp.bottom).inset(-12)
            maker.leading.equalToSuperview()
        }

        var width: CGFloat = 0
        let maxWidth: CGFloat = 520

        var currentStackView = NSStackView()
        currentStackView.spacing = 6

        for title in self.timeExamples {
            let exampleView = TimeExampleView()
            exampleView.label.text = title

            let size = exampleView.fittingSize
            if width + size.width > maxWidth {
                self.contentStackView.addArrangedSubview(currentStackView)
                self.contentStackView.setCustomSpacing(6, after: currentStackView)
                currentStackView = NSStackView()
                currentStackView.spacing = 6
                currentStackView.addArrangedSubview(exampleView)
                width = size.width
            } else {
                currentStackView.addArrangedSubview(exampleView)
                width += size.width
            }
        }
        self.contentStackView.addArrangedSubview(currentStackView)
    }
}
