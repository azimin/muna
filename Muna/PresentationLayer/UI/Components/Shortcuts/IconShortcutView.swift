//
//  IconShortcutView.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class IconShortcutView: View {
    let imageView = ImageView().withIsHidden(true)
    let iconLabel = Label(fontStyle: .bold, size: 11)
        .withIsHidden(true)
        .withTextColorStyle(.newTitle)

    init(modifierFlags: NSEvent.ModifierFlags) {
        var iconString: String

        switch modifierFlags {
        case .command:
            iconString = Key.command.description
        case .shift:
            iconString = Key.shift.description
        case .option:
            iconString = Key.option.description
        case .control:
            iconString = Key.control.description
        default:
            assertionFailure("No supported key")
            iconString = ""
        }
        super.init(frame: .zero)
        self.setup()

        self.iconLabel.text = iconString

        self.iconLabel.isHidden = false
    }

    override func updateLayer() {
        super.updateLayer()
        self.backgroundColor = NSColor.color(.grayBackground)
        self.imageView.image = self.imageView.image?.tint(color: NSColor.color(.newTitle))
    }

    init(key: Key) {
        var text: String?
        var image: NSImage?

        switch key {
        case .upArrow:
            image = NSImage(named: NSImage.Name("key-up"))
        case .downArrow:
            image = NSImage(named: NSImage.Name("key-down"))
        case .tab:
            image = NSImage(named: NSImage.Name("icon_tab"))
        case .return:
            text = key.description
        default:
            text = key.description
        }

        super.init(frame: .zero)
        self.setup()

        if let image = image {
            self.imageView.image = image.tint(color: NSColor.color(.newTitle))
            self.imageView.isHidden = false
        }

        if let text = text {
            self.iconLabel.text = text.uppercased()
            self.iconLabel.isHidden = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.layer?.cornerRadius = 3

        let stackView = NSStackView(views: [self.imageView, self.iconLabel])
        stackView.spacing = 0

        self.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
