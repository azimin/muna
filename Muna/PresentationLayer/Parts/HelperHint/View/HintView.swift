//
//  HintView.swift
//  Muna
//
//  Created by Egor Petrov on 14.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class HintView: View {
    let partShorcutView = ShortcutView(item: Preferences.DefaultItems.defaultActivationShortcut.item)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.backgroundColor = ColorStyle.backgroundOverlay.color

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.addSubview(self.partShorcutView)
        self.partShorcutView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
