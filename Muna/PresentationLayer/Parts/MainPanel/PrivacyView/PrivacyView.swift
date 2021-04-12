//
//  PrivacyView.swift
//  Muna
//
//  Created by Alexander on 4/1/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class PrivacyView: View {
    let stackView = NSStackView(
        orientation: .horizontal,
        alignment: .centerY,
        distribution: .fill
    )

    let privacyPolicyButton = Button(fontStyle: .medium, size: 13)
        .withText("Privacy Policy")
        .withTextColorStyle(.titleAccent)

    let dotView = View()
        .withBackgroundColorStyle(.title60Accent)

    let termsOfUseButton = Button(fontStyle: .medium, size: 13)
        .withText("Terms Of Use")
        .withTextColorStyle(.titleAccent)

    let anotherDotView = View()
        .withBackgroundColorStyle(.title60Accent)

    let restoreButton = Button(fontStyle: .medium, size: 13)
        .withText("Restore Purchases")
        .withTextColorStyle(.titleAccent)

    override func viewSetup() {
        self.addSubview(self.stackView)
        self.stackView.spacing = 4
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.dotView.snp.makeConstraints { (make) in
            make.size.equalTo(4)
        }
        self.dotView.layer?.cornerRadius = 2

        self.anotherDotView.snp.makeConstraints { (make) in
            make.size.equalTo(4)
        }
        self.anotherDotView.layer?.cornerRadius = 2

        self.stackView.addArrangedSubview(self.privacyPolicyButton)
        self.stackView.addArrangedSubview(self.dotView)
        self.stackView.addArrangedSubview(self.termsOfUseButton)
        self.stackView.addArrangedSubview(self.anotherDotView)
        self.stackView.addArrangedSubview(self.restoreButton)
    }
}
