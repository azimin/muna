//
//  ShortcutItemView.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutItemView: View {
    enum Key {
        case command
        case enter
        case shift
        case option
        case control
        case up
        case down
        case char(value: String)
        case number(value: Int)

        var image: NSImage? {
            let name: String?
            switch self {
            case .command:
                name = "icon_cmd"
            default:
                name = nil
            }

            if let name = name {
                return NSImage(named: NSImage.Name(name))
            }
            return nil
        }

        var name: String? {
            switch self {
            case .command:
                return "Cmd"
            case .enter:
                return "Enter"
            case .shift:
                return "Shift"
            case .option:
                return "Option"
            case .control:
                return "Control"
            case let .char(value):
                return "\(value)"
            case let .number(value):
                return "\(value)"
            case .up, .down:
                return nil
            }
        }
    }

    let imageView = ImageView()
    let label = Label(fontStyle: .bold, size: 7)

    private let key: Key
    init(key: Key) {
        self.key = key
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.layer?.cornerRadius = 3
        self.backgroundColor = NSColor.color(.white60alpha)

        let stackView = NSStackView(views: [self.imageView, self.label])
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
