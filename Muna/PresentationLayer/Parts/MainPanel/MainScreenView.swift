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
    let panelPresentationView = MainPanelPresentationAnimationView()
    let mainPanelView = MainPanelView()
    let shortcutsView = MainPanelShortcutsView(style: .withoutShortcutsButton)
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
        self.addSubview(self.panelPresentationView)
        self.panelPresentationView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview()
        }

        self.panelPresentationView.addSubview(self.mainPanelView)
        self.mainPanelView.wantsLayer = true
        self.mainPanelView.layer?.cornerRadius = 12
        self.mainPanelView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.trailing.bottom.equalToSuperview().inset(
                NSEdgeInsets(top: 36, left: 12, bottom: 12, right: 12)
            )
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
            self.hideShortcutsView()
        } else {
            self.showShortcutsView()
        }
    }

    func showShortcutsView() {
        self.isShortcutsShowed = true
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
        self.isShortcutsShowed = false
        self.shortcutsView.removeFromSuperview()
    }
}
