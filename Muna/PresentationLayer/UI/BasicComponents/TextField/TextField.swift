//
//  TextField.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol TextFieldDelegate: AnyObject {
    func textFieldTextDidChange(textField: TextField, text: String)
}

class TextField: View, NSTextFieldDelegate {
    let textField = ActionedTextField()
    let clearButton = Button()
        .withImageName("icon_text_field_clear", color: .titleAccent)

    private(set) var isInFocus: Bool = false

    weak var delegate: TextFieldDelegate?

    var placeholder: String? {
        get {
            return self.textField.placeholderAttributedString?.string
        }
        set {
            if let placeholder = newValue {
                self.textField.placeholderAttributedString = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: NSColor.color(.title60Accent),
                        NSAttributedString.Key.font: FontStyle.customFont(style: .medium, size: 12),
                    ]
                )
            } else {
                self.textField.placeholderAttributedString = nil
            }
        }
    }

    // Show clear button
    private let clearable: Bool

    init(clearable: Bool, numberOfLines: Int) {
        self.clearable = clearable
        self.textField.numberOfLines = numberOfLines
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.backgroundColor = NSColor.color(.lightOverlay)
        self.layer?.cornerRadius = 4
        self.setBorder(isFocused: false)

        self.textField.delegate = self

        self.addSubview(self.textField)
        self.textField.isFocused = { [weak self] isFocused in
            self?.setBorder(isFocused: isFocused)
        }

        self.textField.textColor = NSColor.color(.titleAccent)
        self.textField.wantsLayer = true
        self.textField.drawsBackground = false
        self.textField.focusRingType = .none
        self.textField.isBezeled = false

        self.textField.snp.makeConstraints { maker in
            maker.top.bottom.leading.equalToSuperview().inset(NSEdgeInsets(
                top: 4,
                left: 5,
                bottom: 4,
                right: 5
            ))
        }

        self.addSubview(self.clearButton)
        self.clearButton.isHidden = true
        self.clearButton.snp.makeConstraints { maker in
            maker.leading.equalTo(self.textField.snp.trailing).inset(-6)
            maker.trailing.equalToSuperview().inset(6)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(8)
        }
        self.clearButton.action = #selector(self.clear)
    }

    override func updateLayer() {
        super.updateLayer()
        self.setBorder(isFocused: self.isInFocus)
    }

    @objc
    func clear() {
        self.textField.stringValue = ""
        self.clearButton.isHidden = true
        self.delegate?.textFieldTextDidChange(textField: self, text: "")
    }

    func setBorder(isFocused: Bool) {
        self.isInFocus = isFocused

        if isFocused {
            self.layer?.borderWidth = 2
            self.layer?.borderColor = CGColor.color(.blueSelected)
        } else {
            self.layer?.borderWidth = 1
            self.layer?.borderColor = CGColor.color(.titleAccent)
        }
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? ActionedTextField else {
            appAssertionFailure("Wrong object")
            return
        }

        if textField.stringValue.isEmpty == false, self.clearable {
            self.clearButton.isHidden = false
        } else {
            self.clearButton.isHidden = true
        }

        self.delegate?.textFieldTextDidChange(
            textField: self,
            text: textField.stringValue
        )
    }
}
