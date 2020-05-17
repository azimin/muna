//
//  AlertView.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class PopupView: View {
    enum Style {
        case withShortcutsButton
        case withoutShortcutsButton
    }

    let vialPlate = NSVisualEffectView()
    let vialPlateOverlay = View()

    let closeButton = Button()
        .withImageName("icon_close")

    let shortcutsButton = Button().withImageName("icon_cmd", color: .button)

    init(style: Style) {
        super.init(frame: .zero)

        self.setup(forStyle: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.vialPlate.material = Theme.current.visualEffectMaterial
        _ = self.closeButton.withImageName("icon_close", color: .title60Accent)
    }

    func setup(forStyle style: Style) {
        self.backgroundColor = NSColor.clear

        self.layer?.cornerRadius = 12
        self.layer?.masksToBounds = true

        self.addSubview(self.vialPlate)
        self.vialPlate.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.vialPlate.wantsLayer = true
        self.vialPlate.blendingMode = .behindWindow
        self.vialPlate.state = .active
        self.vialPlate.layer?.cornerRadius = 12

        self.addSubview(self.vialPlateOverlay)
        self.vialPlateOverlay.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.vialPlateOverlay.layer?.cornerRadius = 12
        self.vialPlateOverlay.layer?.borderWidth = 1
        self.vialPlateOverlay.layer?.borderColor = CGColor.color(.separator)
        self.vialPlateOverlay.backgroundColor = NSColor.color(.foregroundOverlay)

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { maker in
            maker.top.trailing.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 0,
                bottom: 0,
                right: 12
            ))
            maker.size.equalTo(CGSize(width: 16, height: 16))
        }

        switch style {
        case .withShortcutsButton:
            self.addSubview(self.shortcutsButton)
            self.shortcutsButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.trailing.equalTo(self.closeButton.snp.leading).offset(-16)
                make.size.equalTo(14)
            }
        case .withoutShortcutsButton:
            break
        }
    }
}
