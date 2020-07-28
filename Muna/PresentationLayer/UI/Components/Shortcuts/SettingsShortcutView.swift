//
//  SettingsShortcutView.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SettingsShortcutView: View {
    let button = Button(image: NSImage(named: "Close")!.tint(color: ColorStyle.newTitle.color), target: nil, action: nil)

    init(item: ShortcutItem) {
        super.init(frame: .zero)
        self.setup(item: item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(item: ShortcutItem) {
        self.layer?.cornerRadius = 3
        self.backgroundColor = NSColor.color(.lightForegroundOverlay)

        let stackView = NSStackView()
        stackView.spacing = 0
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(25)
        }

        self.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }

        var views: [NSView] = []

        for flag in item.modifiers.splitToSingleFlags(discardNotImportant: false) {
            let shortcutItemView = IconShortcutView(modifierFlags: flag)

            views.append(shortcutItemView)
        }

        let shortcutItemView = IconShortcutView(key: item.key)
        views.append(shortcutItemView)
        views.forEach { stackView.addArrangedSubview($0) }
    }
}
