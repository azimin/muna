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
            for flag in item.modifiers.splitToSingleFlags(discardNotImportant: false) {
                let shortcutItemView = ShortcutItemView(modifierFlags: flag)
                views.append(shortcutItemView)
                views.append(self.symbolView(symbol: "+"))
            }

            let shortcutItemView = ShortcutItemView(key: item.key)
            views.append(shortcutItemView)
            views.append(self.symbolView(symbol: "/"))
        }
        if oneOfItem.isEmpty == false {
            views.removeLast()
        }
        views.forEach { stackView.addArrangedSubview($0) }
    }

    func symbolView(symbol: String) -> Label {
        let label = Label(fontStyle: .bold, size: 11)
        label.text = symbol
        return label
    }
}
