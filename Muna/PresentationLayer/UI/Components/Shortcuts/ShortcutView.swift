//
//  ShortcutView.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutView: View {
    init(item: ShortcutItem) {
        super.init(frame: .zero)
        self.setup(oneOfItem: [item])
    }

    init(oneOfItem: [ShortcutItem]) {
        super.init(frame: .zero)
        self.setup(oneOfItem: oneOfItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(oneOfItem: [ShortcutItem]) {
        let stackView = NSStackView()
        stackView.spacing = 3
        self.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        var views: [NSView] = []

        for item in oneOfItem {
            for flag in item.modifiers.splitToSingleFlags() {
                let shortcutItemView = ShortcutItemView(modifierFlags: flag)
                views.append(shortcutItemView)
                views.append(self.symbolView(symbol: "+"))
            }

            let shortcutItemView = ShortcutItemView(key: item.key)
            views.append(shortcutItemView)
            views.append(self.symbolView(symbol: "/"))
        }
        views.removeLast()
        views.forEach { stackView.addArrangedSubview($0) }
    }

    func symbolView(symbol: String) -> Label {
        let label = Label(fontStyle: .bold, size: 11)
        label.text = symbol
        return label
    }
}

extension NSEvent.ModifierFlags {
    func splitToSingleFlags() -> [NSEvent.ModifierFlags] {
        var result: [NSEvent.ModifierFlags] = []

        if self.contains(.capsLock) {
            result.append(.capsLock)
        }

        if self.contains(.shift) {
            result.append(.shift)
        }

        if self.contains(.option) {
            result.append(.option)
        }

        if self.contains(.command) {
            result.append(.command)
        }

        if self.contains(.numericPad) {
            result.append(.numericPad)
        }

        if self.contains(.help) {
            result.append(.help)
        }

        if self.contains(.function) {
            result.append(.function)
        }

        if self.contains(.deviceIndependentFlagsMask) {
            result.append(.deviceIndependentFlagsMask)
        }

        return result
    }
}
