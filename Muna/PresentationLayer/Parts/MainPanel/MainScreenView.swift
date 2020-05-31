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
    var changeTimeView: TaskChangeTimeGlobalView?

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

    func hideChangeTimeView() {
        guard let changeTimeView = self.changeTimeView else {
            return
        }
        changeTimeView.removeFromSuperview()
        self.changeTimeView = nil
    }
}
