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

    let restoreLoader = NSProgressIndicator()

    var isRestoreLoading: Bool = false {
        didSet {
            self.restoreLoader.isHidden = self.isRestoreLoading == false
            self.restoreButton.isHidden = self.isRestoreLoading
            if self.isRestoreLoading {
                self.restoreLoader.isIndeterminate = true
                self.restoreLoader.usesThreadedAnimation = true
                self.restoreLoader.startAnimation(nil)
            } else {
                self.restoreLoader.stopAnimation(nil)
            }
        }
    }

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

        self.restoreLoader.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
        self.restoreLoader.style = .spinning
        self.restoreLoader.isHidden = true

        self.stackView.addArrangedSubview(self.privacyPolicyButton)
        self.stackView.addArrangedSubview(self.dotView)
        self.stackView.addArrangedSubview(self.termsOfUseButton)
        self.stackView.addArrangedSubview(self.anotherDotView)
        self.stackView.addArrangedSubview(self.restoreButton)
        self.stackView.addArrangedSubview(self.restoreLoader)

        self.privacyPolicyButton.target = self
        self.privacyPolicyButton.action = #selector(self.openPrivacy)

        self.termsOfUseButton.target = self
        self.termsOfUseButton.action = #selector(self.openTerms)
    }

    @objc
    func openPrivacy() {
        let url = URL(string: "https://muna.live/privacy")!
        NSWorkspace.shared.open(url)
    }

    @objc
    func openTerms() {
        let url = URL(string: "https://muna.live/terms")!
        NSWorkspace.shared.open(url)
    }
}
