//
//  ActionedTextField.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ActionedTextField: NSTextField {
    var isFocused: BoolBlock?
    var numberOfLines: Int = 1

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.wantsLayer = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.resignActive), name: NSControl.textDidEndEditingNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        self.setBorder(isFocused: true)
        return super.becomeFirstResponder()
    }

    @objc
    func resignActive(_ notification: Notification) {
        if notification.object as AnyObject? === self {
            self.setBorder(isFocused: false)
        }
    }

    func setBorder(isFocused: Bool) {
        self.isFocused?(isFocused)
    }

    override var intrinsicContentSize: NSSize {
        var value = super.intrinsicContentSize

        if self.numberOfLines == 1 {
            return value
        }

        guard let font = self.font else {
            return value
        }

        let width = self.frame.width - 4
        let defaultHeight = "1".heightWithConstrainedWidth(width: width, font: font)
        let expectedHeight = self.attributedStringValue.height(containerWidth: width)

        var expectedNumberOfLines = Int(round(expectedHeight / defaultHeight))
        expectedNumberOfLines = min(expectedNumberOfLines, self.numberOfLines)
        value.height = CGFloat(expectedNumberOfLines) * defaultHeight

        return value
    }
}

fileprivate extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }
}

fileprivate extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return boundingBox.height
    }
}
