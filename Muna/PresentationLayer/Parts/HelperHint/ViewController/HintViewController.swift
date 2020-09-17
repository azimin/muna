//
//  HintViewController.swift
//  Muna
//
//  Created by Egor Petrov on 14.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class HintViewController: NSViewController, ViewHolder {
    typealias ViewType = HintView

    override func loadView() {
        self.view = HintView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.closeButton.target = self
        self.rootView.closeButton.action = #selector(closeHint)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.rootView.addTrackingArea(
            NSTrackingArea(
                rect: self.rootView.bounds,
                options: [.activeAlways, .mouseEnteredAndExited],
                owner: self,
                userInfo: nil
            )
        )
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.rootView.closeButton.isHidden = false
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.rootView.closeButton.isHidden = true
    }

    @objc
    private func closeHint() {
        ServiceLocator.shared.windowManager.closeHintPopover()
    }
}
