//
//  InternalPopupView.swift
//  Muna
//
//  Created by Alexander on 9/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class PanelPopupView: View {
    let vialPlate = NSVisualEffectView()
    let vialPlateOverlay = View()
        .withBackgroundColorStyle(.lightForegroundOverlay)

    let closeButton = Button()
        .withImageName("icon_close", color: .title60Accent)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.vialPlate.material = Theme.current.visualEffectMaterial
    }

    private func setup() {
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
    }
}
