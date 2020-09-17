//
//  SmartAssistentView.swift
//  Muna
//
//  Created by Alexander on 9/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class SmartAssistentView: View {
    let backgroundView = View()
        .withBackgroundColorStyle(.assitentPlateBackground)

    let arrowIcon = Button()
        .withImageName(
            "icon_question",
            color: .assitentLeftColor
        )

    let label = Label(fontStyle: .bold, size: 12)
        .withText("Smart Assistent")

    var pressAction: VoidBlock?

    override func updateLayer() {
        super.updateLayer()

        self.label.applyGradientText(colors: [
            ColorStyle.assitentLeftColor.color.cgColor,
            ColorStyle.assitentRightColor.color.cgColor,
        ])
    }

    override func viewSetup() {
        super.viewSetup()

        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(self.arrowIcon)
        self.arrowIcon.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(
                NSEdgeInsets(top: 5, left: 0, bottom: 5, right: 8)
            )
            make.leading.equalTo(self.arrowIcon.snp.trailing).inset(-6)
            make.centerY.equalToSuperview()
        }
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.backgroundView.alphaValue = 0.7
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)

        if let point = self.window?.contentView?.convert(event.locationInWindow, to: self) {
            // swiftlint:disable legacy_nsgeometry_functions
            if NSPointInRect(point, self.bounds) {
                self.pressAction?()
            }
        }
        self.backgroundView.alphaValue = 1
    }
}
