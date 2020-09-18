//
//  MainPanelBackgroundView.swift
//  Muna
//
//  Created by Alexander on 9/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class MainPanelBackgroundView: View {
    let backgroundView = View()
    let visualView = NSVisualEffectView()
    let visualOverlayView = View()
        .withBackgroundColorStyle(.lightForegroundOverlay)

    override func updateLayer() {
        super.updateLayer()
        self.visualView.material = Theme.current.visualEffectMaterial
        self.backgroundView.layer?.borderColor = CGColor.color(.separator)
    }

    override func viewSetup() {
        super.viewSetup()

        self.layer?.cornerRadius = 12

        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.backgroundView.layer?.borderWidth = 0.5

        self.backgroundView.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.state = .active
        self.visualView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.visualOverlayView)
        self.visualOverlayView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
