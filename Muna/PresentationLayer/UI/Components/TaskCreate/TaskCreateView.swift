//
//  TaskCreateView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskCreateView: View {
    let vialPlate = NSVisualEffectView()

    let closeButton = Button()
        .withImageName("icon_close")

    let contentStackView = NSStackView()

    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.snp.makeConstraints { (maker) in
            maker.width.equalTo(220)
        }
        self.layer?.cornerRadius = 12
        self.layer?.masksToBounds = true

        self.addSubview(self.vialPlate)
        self.vialPlate.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.vialPlate.wantsLayer = true
        self.vialPlate.blendingMode = .withinWindow
        self.vialPlate.material = .dark
        self.vialPlate.state = .active
        self.vialPlate.layer?.cornerRadius = 12

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (maker) in
            maker.top.trailing.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 0,
                bottom: 0,
                right: 12
            ))
            maker.size.equalTo(CGSize(width: 16, height: 16))
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 12,
                bottom: 16,
                right: 12
            ))
            maker.top.equalTo(self.closeButton.snp.bottom).inset(16)
        }

        let reminderTextField = TextField()
        let commentTextField = TextField()

        self.contentStackView.addArrangedSubview(reminderTextField)
        self.contentStackView.addArrangedSubview(commentTextField)
    }
}
