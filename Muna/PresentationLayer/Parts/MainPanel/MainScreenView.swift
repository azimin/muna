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
    let assistentPanelView = MainPanelBackgroundView()
    let shortcutsView = MainPanelShortcutsView(style: .withoutShortcutsButton)
    var changeTimeView: TaskChangeTimeGlobalView?
    var hintView: PanelHintView?

    var isShortcutsShowed = false

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.assistenPanelPresentationView)
        self.assistenPanelPresentationView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview()
        }

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

        self.assistenPanelPresentationView.addSubview(self.assistentPanelView)
        self.assistentPanelView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.trailing.bottom.equalToSuperview().inset(
                NSEdgeInsets(top: 36, left: 12, bottom: 12, right: 12 + 16 + WindowManager.panelWindowFrameWidth)
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
        ServiceLocator.shared.analytics.executeControl(
            control: .panelShortcuts,
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

    func hideShortcutsView() {
        self.isShortcutsShowed = false
        self.shortcutsView.removeFromSuperview()
    }

    // MARK: - Hint

    private func hideHint() {
        guard let hintView = self.hintView else {
            return
        }

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            hintView.animator().layer?.transform = CATransform3DMakeScale(0.01, 0.01, 1)
        }, completionHandler: {
            hintView.removeFromSuperview()
        })
    }

    private func showHint() {
        self.hintView?.removeFromSuperview()
        let hintView = PanelHintView(hintItem: .previewImage)
        self.addSubview(hintView)
        hintView.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.mainPanelView.snp.bottom)
            maker.width.equalTo(self.mainPanelView.snp.width)
            maker.trailing.equalTo(self.mainPanelView.snp.leading).inset(-12)
        }
        self.hintView = hintView

        hintView.layer?.transform = CATransform3DMakeScale(0.01, 0.01, 1)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            hintView.animator().layer?.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        }
    }
}
