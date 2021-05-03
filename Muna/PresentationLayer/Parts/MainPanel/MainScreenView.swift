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
    let assistenPanelPresentationView = MainPanelPresentationAnimationView(
        style: .smartAssistent
    )
    let mainPanelPresentationView = MainPanelPresentationAnimationView(
        style: .mainPanel
    )
    let mainPanelView = MainPanelView()
    let assistentPanelView = AssistentPanelView()
    let shortcutsView = MainPanelShortcutsView(style: .withoutShortcutsButton)
    var changeTimeView: TaskChangeGlobalView?
    var changeCommentView: TaskChangeGlobalView?

    var isShortcutsShowed = false

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
//        self.addSubview(self.assistenPanelPresentationView)
//        self.assistenPanelPresentationView.snp.makeConstraints { maker in
//            maker.top.trailing.bottom.equalToSuperview()
//        }

        self.addSubview(self.mainPanelPresentationView)
        self.mainPanelPresentationView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview()
        }

        self.mainPanelPresentationView.addSubview(self.mainPanelView)
        self.mainPanelView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.trailing.bottom.equalToSuperview().inset(
                NSEdgeInsets(top: 36, left: 12, bottom: 12, right: 12)
            )
            maker.width.equalTo(WindowManager.panelWindowFrameWidth)
        }

//        self.assistenPanelPresentationView.addSubview(self.assistentPanelView)
//        self.assistentPanelView.snp.makeConstraints { maker in
//            maker.leading.equalToSuperview()
//            maker.top.trailing.bottom.equalToSuperview().inset(
//                NSEdgeInsets(top: 36, left: 12, bottom: 12, right: 12 + 16 + WindowManager.panelWindowFrameWidth)
//            )
//            maker.width.equalTo(WindowManager.panelWindowFrameWidth)
//        }
    }

    func showChangeTimeView(itemModel: ItemModel, closeHandler: CloseHandler) {
        self.hideChangeCommentView()
        self.hideChangeTimeView()

        let changeTimeView = TaskChangeGlobalView(
            itemModel: itemModel,
            style: itemModel.savingTypeCasted == .screenshot ? .editTimeWithImage : .editTimeWithoutImage,
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

    func showChangeCommentView(itemModel: ItemModel, closeHandler: CloseHandler) {
        self.hideChangeCommentView()
        self.hideChangeTimeView()

        let changeCommentView = TaskChangeGlobalView(
            itemModel: itemModel,
            style: itemModel.savingTypeCasted == .screenshot ? .editCommentWithImage : .editCommentWithoutImage,
            closeHandler: closeHandler
        )

        self.addSubview(changeCommentView)
        changeCommentView.snp.makeConstraints { maker in
            maker.trailing.equalTo(self.mainPanelView.snp.leading).offset(-16)
            maker.top.equalToSuperview().inset(60)
        }

        self.changeCommentView = changeCommentView
        self.window?.makeFirstResponder(changeCommentView)
    }

    func toggleShortutsView() {
        if self.isShortcutsShowed {
            self.hideShortcutsView()
        } else {
            self.showShortcutsView()
        }
    }

    func showShortcutsView() {
        ServiceLocator.shared.analytics.executeControl(
            control: .showShortcutsPanel,
            byShortcut: false
        )

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

    func hideChangeCommentView() {
        guard let changeCommentView = self.changeCommentView else {
            return
        }
        changeCommentView.removeFromSuperview()
        self.changeCommentView = nil
    }

    func hideShortcutsView() {
        self.isShortcutsShowed = false
        self.shortcutsView.removeFromSuperview()
    }
}
