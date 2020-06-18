//
//  MainScreenView.swift
//  Muna
//
//  Created by Alexander on 5/26/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class MainScreenView: NSView {
    let mainPanelView = MainPanelView()
    let shortcutsView = MainPanelShortcutsView(style: .withShortcutsButton)
    var changeTimeView: TaskChangeTimeGlobalView?

    var isShortcutsShowed = false

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.mainPanelView)
        self.mainPanelView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview()
            maker.width.equalTo(WindowManager.panelWindowFrameWidth)
        }
    }

    func showChangeTimeView(itemModel: ItemModel, closeHandler: CloseHandler) {
        self.hideChangeTimeView()

        let changeTimeView = TaskChangeTimeGlobalView(
            itemModel: itemModel,
            style: .withImage,
            closeHandler: closeHandler
        )

        self.addSubview(changeTimeView)
        changeTimeView.snp.makeConstraints { maker in
            maker.trailing.equalTo(self.mainPanelView.snp.leading).offset(-16)
            maker.top.equalToSuperview().inset(60)
        }

        self.changeTimeView = changeTimeView
        self.window?.makeFirstResponder(changeTimeView)
    }

    func toggleShortutsView() {
        if self.isShortcutsShowed {
            self.isShortcutsShowed.toggle()
            self.hideShortcutsView()
        } else {
            self.isShortcutsShowed.toggle()
            self.showShortcutsView()
        }
    }

    func showShortcutsView() {
        self.addSubview(self.shortcutsView)
        self.shortcutsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.mainPanelView.snp.leading).offset(-16)
        }
    }

    func hideChangeTimeView() {
        guard let changeTimeView = self.changeTimeView else {
            return
        }
        changeTimeView.removeFromSuperview()
        self.changeTimeView = nil
    }

    func hideShortcutsView() {
        self.shortcutsView.removeFromSuperview()
    }
}
