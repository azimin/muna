//
//  TextTaskCreationViewController.swift
//  Muna
//
//  Created by Egor Petrov on 20.10.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

final class TextTaskCreationViewController: NSViewController, ViewHolder {
    typealias ViewType = TaskCreateView

    override func loadView() {
        self.view = TaskCreateView(savingProcessingService: ServiceLocator.shared.savingService)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView.delegate = self
    }

    func hide(completion: VoidBlock?) {
        self.rootView.clear()

        completion?()
    }

    @objc
    private func handleCloseShortcutsButton() {
        self.taskCreateShortCutsView.isHidden = true
        self.isShortcutsViewShowed = false
    }

    func showShortcutsView(aroundViewFrame frame: NSRect) {
        self.taskCreateShortCutsView.frame = self.positionForShortcutsView(
            rect: self.taskCreateShortCutsView.frame,
            aroundRect: frame
        )
        self.taskCreateShortCutsView.isHidden = false
        self.isShortcutsViewShowed = true
        self.layoutSubtreeIfNeeded()
    }
}

extension TextTaskCreationViewController: TaskCreateViewDelegate {
    func shortcutsButtonTapped() {
        if self.isShortcutsViewShowed {
            self.handleCloseShortcutsButton()
        } else {
            self.showShortcutsView(aroundViewFrame: self.reminderSetupPopup.frame)
        }
    }

    func closeScreenshot() {
        self.delegate?.escapeWasTapped()
    }
}
