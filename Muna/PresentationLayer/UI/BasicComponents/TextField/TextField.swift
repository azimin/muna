//
//  TextField.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TextField: View {
    let textField = ActionedTextField()

    weak var delegate: NSTextFieldDelegate? {
        didSet {
            self.textField.delegate = self.delegate
        }
    }

    var placeholder: String? {
        set {
            if let placeholder = newValue {
                self.textField.placeholderAttributedString = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: NSColor.color(.white60),
                        NSAttributedString.Key.font: FontStyle.customFont(style: .medium, size: 12),
                    ]
                )
            } else {
                self.textField.placeholderAttributedString = nil
            }
        }
        get {
            return self.textField.placeholderAttributedString?.string
        }
    }

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.layer?.cornerRadius = 4
        self.setBorder(isFocused: false)

        self.addSubview(self.textField)
        self.textField.isFocused = { [weak self] isFocused in
            self?.setBorder(isFocused: isFocused)
        }

        self.textField.textColor = NSColor.color(.white)
        self.textField.wantsLayer = true
        self.textField.drawsBackground = false
        self.textField.focusRingType = .none
        self.textField.isBezeled = false

        self.textField.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(
                top: 4,
                left: 5,
                bottom: 4,
                right: 5
            ))
        }
    }

    func setBorder(isFocused: Bool) {
        if isFocused {
            self.layer?.borderWidth = 2
            self.layer?.borderColor = CGColor.color(.blueSelection)
        } else {
            self.layer?.borderWidth = 1
            self.layer?.borderColor = CGColor.color(.white60)
        }
    }
}
