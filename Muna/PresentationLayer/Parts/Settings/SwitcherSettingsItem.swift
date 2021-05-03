//
//  SwitcherSwitchItem.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit
class SwitcherSettingsItem: View {
    let titleLabel: Label

    let descriptionLabel: NSTextView
    private var descriptionHeightConstraint: Constraint?

    let switcher = Switcher()

    private let style: SettingsItemView.Style

    private let descriptionSize: CGFloat

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

        self.descriptionSize = descriptionSize

        self.titleLabel = Label(fontStyle: .bold, size: titleSize)
            .withTextColorStyle(.titleAccent)

        self.descriptionLabel = NSTextView()
        self.descriptionLabel.font = FontStyle.customFont(style: .medium, size: descriptionSize)
        self.descriptionLabel.textColor =  ColorStyle.title60Accent.color
        self.descriptionLabel.drawsBackground = false
        self.descriptionLabel.isEditable = false
        self.descriptionLabel.isSelectable = true
        self.descriptionLabel.textContainerInset = .zero

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

        self.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { make in
            if self.style == .oneLine {
                make.bottom.top.equalToSuperview()
            } else {
                make.centerY.equalToSuperview()
            }
            make.trailing.equalToSuperview()
        }

        if self.style != .oneLine {
            self.addSubview(self.descriptionLabel)
            self.descriptionLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(-3.5)
                make.trailing.equalTo(self.switcher.snp.leading).inset(8)
                make.bottom.equalToSuperview()
                self.descriptionHeightConstraint = make.height.equalTo(0).constraint
                make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            }
        }
    }

    func setDescription(_ string: String, withLink link: String? = nil, linkedPart: String? = nil) {
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: FontStyle.customFont(style: .medium, size: descriptionSize) as NSFont,
                .foregroundColor: ColorStyle.title60Accent.color as NSColor
            ]
        )

        if let link = link, let linkedPart = linkedPart {
            attributedString.beginEditing()

            let rangeOfText = (attributedString.string as NSString).range(of: linkedPart)
            
            attributedString.addAttribute(.link, value: link, range: rangeOfText)
            
            attributedString.endEditing()
        }
    
        self.descriptionHeightConstraint?.update(offset: attributedString.calculateHeight(forWidth: self.descriptionLabel.frame.width))
        
        self.descriptionLabel.textStorage?.setAttributedString(attributedString)
    }
}
