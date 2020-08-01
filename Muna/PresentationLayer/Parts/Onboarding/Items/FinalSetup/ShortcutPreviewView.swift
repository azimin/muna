//
//  ShortcutPreviewView.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import MASShortcut

class ShortcutPreviewView: NSView {
    let titleLabel = Label(fontStyle: .bold, size: 16)
        .withTextColorStyle(.titleAccent)
        .withAligment(.center)

    let previewImageView = ImageView()

    let shortcutView: MASShortcutView

    init(title: String, imageName: String, itemUDKey: String) {
        self.shortcutView = MASShortcutView()
        self.shortcutView.associatedUserDefaultsKey = itemUDKey
        self.titleLabel.text = title
        self.previewImageView.image = NSImage(named: imageName)

        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        self.addSubview(self.previewImageView)
        self.previewImageView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(158)
        }

        self.addSubview(self.shortcutView)
        self.shortcutView.snp.makeConstraints { make in
            make.top.equalTo(self.previewImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
