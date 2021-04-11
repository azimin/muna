//
//  CancelSubscriptionView.swift
//  Muna
//
//  Created by Alexander on 4/11/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class CancelSubscriptionView: View {
    let stackView = NSStackView(
        orientation: .horizontal,
        alignment: .centerY,
        distribution: .fill
    )

    let titleLabel = Label(fontStyle: .medium, size: 13)
        .withText("Want to cancel?")
        .withTextColorStyle(.title60Accent)

    let howButton = Button(fontStyle: .medium, size: 13)
        .withText("Check how")
        .withTextColorStyle(.titleAccent)

    override func viewSetup() {
        self.addSubview(self.stackView)
        self.stackView.spacing = 0
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.howButton)
    }
}
