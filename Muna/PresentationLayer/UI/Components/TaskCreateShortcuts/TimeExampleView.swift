//
//  TimeExampleView.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TimeExampleView: View {
    let label = Label(fontStyle: .bold, size: 11)
        .withTextColorStyle(.titleAccent)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.backgroundColor = NSColor.color(.grayBackground)
    }

    func setup() {
        self.layer?.cornerRadius = 3

        self.addSubview(self.label)
        self.label.snp.makeConstraints { maker in
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
