//
//  Button.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class Button: NSButton {
    var colorStyle: ColorStyle? {
        didSet {
            self.updateTitle()
        }
    }

    override var title: String {
        didSet {
            self.updateTitle()
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let cell = ButtonCell()
        self.cell = cell

        self.isBordered = false
        cell.highlightedAction = { [weak self] flag in
            self?.updateHighlight(isHighlighted: flag)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateTitle() {
        guard let colorStyle = self.colorStyle else {
            return
        }

        self.attributedTitle =
            NSMutableAttributedString(
                string: self.title,
                attributes: [
                    NSAttributedString.Key.foregroundColor: colorStyle.color,
                    NSAttributedString.Key.font: self.font ?? NSFont.systemFont(ofSize: 16, weight: .bold),
                ]
            )
    }

    func updateHighlight(isHighlighted: Bool) {
        self.layer?.opacity = isHighlighted ? 0.7 : 1.0
    }
}
