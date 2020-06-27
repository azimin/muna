//
//  DebugView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DebugView: View {
    let contentView = View()
//    let contentView = TaskCreateShortcuts()
    var gradientView = NSVisualEffectView()
    let container = SemiTransparentView()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        self.addSubview(self.container)
        self.container.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(300)
        }

        self.container.addSubview(self.gradientView)
        self.gradientView.blendingMode = .behindWindow
        self.gradientView.state = .active
        self.gradientView.material = NSVisualEffectView.Material.dark
        self.gradientView.wantsLayer = true
        self.gradientView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let button = OnboardingButton()
        button.title = "Change"
        self.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        button.target = self
        button.action = #selector(self.changeMaterial)
    }

    var index = 0

    @objc func changeMaterial() {
        let materials: [NSVisualEffectView.Material] = [
            .light,
            .dark,
            .sidebar,
            .underPageBackground,
            .underWindowBackground,
            .contentBackground,
            .toolTip,
            .fullScreenUI,
            .hudWindow,
            .windowBackground,
            .sheet,
            .headerView,
        ]

        self.gradientView.material = NSVisualEffectView.Material(rawValue: self.index) ?? .light
        self.index += 1
    }
}

class SemiTransparentView: NSView {
    var alphaLevel: Double = 0.12

    override var allowsVibrancy: Bool { return true }

    override func draw(_ dirtyRect: NSRect) {
        NSColor(deviceWhite: 255, alpha: self.alphaValue).set()
        dirtyRect.fill()
    }
}
