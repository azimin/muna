//
//  TipPurchaseButton.swift
//  Muna
//
//  Created by Alexander on 4/2/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class TipPurchaseButton: Button {
    enum Style {
        case accent
        case normal
    }

    let titleLabel = Label(fontStyle: .bold, size: 18)
    let subtitleLabel = Label(fontStyle: .bold, size: 18)

    let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.title = ""
        self.setup()

        switch self.style {
        case .accent:
            _ = self.titleLabel.withTextColorStyle(.alwaysWhite)
            _ = self.subtitleLabel.withTextColorStyle(.alwaysWhite60AccentAlpha)
        case .normal:
            _ = self.titleLabel.withTextColorStyle(.titleAccent)
            _ = self.subtitleLabel.withTextColorStyle(.title60AccentAlpha)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 216, height: 80))
        }

        let stackView = NSStackView(
            orientation: .vertical,
            alignment: .centerX,
            distribution: .fill
        )
        stackView.spacing = 0

        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.subtitleLabel)

        switch self.style {
        case .accent:
            _ = self.withBackgroundColorStyle(.purchaseTipButton)
        case .normal:
            self.backgroundColor = .clear
        }

        self.layer?.cornerRadius = 12
    }

    override func updateLayer() {
        super.updateLayer()

        switch self.style {
        case .accent:
            self.layer?.borderWidth = 0
        case .normal:
            self.layer?.borderWidth = 4
            self.layer?.borderColor = ColorStyle.purchaseTipButton.color.cgColor
        }
    }
}
