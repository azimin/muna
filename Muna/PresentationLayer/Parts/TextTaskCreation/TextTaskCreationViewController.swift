//
//  TextTaskCreationViewController.swift
//  Muna
//
//  Created by Egor Petrov on 20.10.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

final class TextTaskCreationViewController: NSViewController, ViewHolder {
    typealias ViewType = TextTaskCreationView

    override func loadView() {
        self.view = TextTaskCreationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.taskCreationView.delegate = self
    }

    func hide(completion: VoidBlock?) {
        self.rootView.taskCreationView.clear()

        completion?()
    }

    @objc
    private func handleCloseShortcutsButton() {
        self.rootView.taskCreateShortCutsView.isHidden = true
        self.rootView.isShortcutsViewShowed = false
    }

    func showShortcutsView(aroundViewFrame frame: NSRect) {
        self.rootView.taskCreateShortCutsView.frame.origin.x = self.rootView.taskCreationView.frame.maxX + 16
        self.rootView.taskCreateShortCutsView.frame.origin.y = self.rootView.taskCreationView.frame.height / 2 + self.rootView.taskCreateShortCutsView.frame.height / 2
        self.rootView.taskCreateShortCutsView.isHidden = false
        self.rootView.isShortcutsViewShowed = true
        self.rootView.layoutSubtreeIfNeeded()
    }
}

extension TextTaskCreationViewController: TaskCreateViewDelegate {
    func closeScreenshot() {
        ServiceLocator.shared.windowManager.hideWindowIfNeeded(.textTaskCreation)
    }

    func shortcutsButtonTapped() {
        if self.rootView.isShortcutsViewShowed {
            self.handleCloseShortcutsButton()
        } else {
            self.showShortcutsView(aroundViewFrame: self.rootView.taskCreationView.frame)
        }
    }
}
