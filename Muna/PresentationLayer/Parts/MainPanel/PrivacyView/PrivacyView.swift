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

    let privacyPolicyButton = Button()
        .withText("Privacy Policy")
        .withTextColorStyle(.titleAccent)

    let dotView = View()
        .withBackgroundColorStyle(.title60Accent)

    let termsOfUseButton = Button()
        .withText("Terms Of Use")
        .withTextColorStyle(.titleAccent)

    override func viewSetup() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.dotView.snp.makeConstraints { (make) in
            make.size.equalTo(4)
        }
        self.dotView.layer?.cornerRadius = 2

        self.stackView.addArrangedSubview(self.privacyPolicyButton)
        self.stackView.addArrangedSubview(self.dotView)
        self.stackView.addArrangedSubview(self.termsOfUseButton)
    }
}
