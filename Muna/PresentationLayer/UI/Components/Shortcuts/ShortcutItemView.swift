//
//  ShortcutItemView.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutItemView: View {
    let imageView = ImageView().withIsHidden(true)
    let iconLabel = Label(fontStyle: .bold, size: 7).withIsHidden(true)
    let label = Label(fontStyle: .bold, size: 7).withIsHidden(true)

    init(modifierFlags: NSEvent.ModifierFlags) {
        let iconString: String
        let textString: String

        switch modifierFlags {
        case .command:
            iconString = Key.command.description
            textString = "Cmd"
        case .shift:
            iconString = Key.shift.description
            textString = "Shift"
        case .option:
            iconString = Key.option.description
            textString = "Option"
        case .control:
            iconString = Key.control.description
            textString = "Control"
        default:
            assertionFailure("No supported key")
            iconString = ""
            textString = "Unknown"
        }
        super.init(frame: .zero)
        self.setup()

        self.iconLabel.text = iconString
        self.label.text = textString

        self.iconLabel.isHidden = false
        self.label.isHidden = false
    }

    init(key: Key) {
        var image: NSImage?
        var text: String?

        switch key {
        case .upArrow:
            image = NSImage(named: NSImage.Name("key-up"))
        case .downArrow:
            image = NSImage(named: NSImage.Name("key-down"))
        default:
            text = key.description
        }

        super.init(frame: .zero)
        self.setup()

        if let image = image {
            self.imageView.image = image
            self.imageView.isHidden = false
        }

        if let text = text {
            self.label.text = text
            self.label.isHidden = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.layer?.cornerRadius = 3
        self.backgroundColor = NSColor.color(.white60alpha)

        let stackView = NSStackView(views: [self.imageView, self.iconLabel, self.label])
        stackView.spacing = 3

        self.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(
                NSEdgeInsets(
                    top: 3,
                    left: 4,
                    bottom: 3,
                    right: 4
                )
            )
        }
    }
}
