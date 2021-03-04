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

    private var timer: Timer?
    private var passedTime = 2

    override func loadView() {
        self.view = TextTaskCreationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.taskCreationView.delegate = self
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.showHintIfNeeded()
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

    func showHintIfNeeded() {
        let nowTime = Date().timeIntervalSince1970
        let isBigGap = nowTime - Preferences.hintShowedForNotesTimeInterval > PresentationLayerConstants.oneHourInSeconds * 2

        guard (Preferences.isNeededToShowIncreaseProductivity && isBigGap) || Preferences.isFirstTimeOfShowingIncreaseProductivityPopup else { return }

        self.timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            guard self.passedTime >= 3 else {
                self.passedTime += 1
                return
            }

            let database = ServiceLocator.shared.itemsDatabase
            let numberOfCreatedItems = database.fetchItems(filter: .uncompleted).count

            if numberOfCreatedItems > 2 {
                ServiceLocator.shared.windowManager.showHintPopover(sender: self.rootView.taskCreationView.shortcutsButton)
            }
            Preferences.isFirstTimeOfShowingIncreaseProductivityPopup = false
            Preferences.hintShowedForNotesTimeInterval = Date().timeIntervalSince1970
            self.passedTime = 0
            timer.invalidate()
            self.timer = nil
        }

        guard let timer = self.timer else {
            appAssertionFailure("Timer can't be allocated on text task creation")
            return
        }

        RunLoop.current.add(timer, forMode: .common)
    }
}

extension TextTaskCreationViewController: TaskCreateViewDelegate {
    func closeScreenshot() {
        ServiceLocator.shared.windowManager.closeHintPopover()
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
