//
//  MainPanelViewController.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainScreenViewController: NSViewController {
    var shortcutsController: ShortcutsController?

    var rootView: MainPanelView {
        return (self.view as! MainScreenView).mainPanelView
    }

    override func loadView() {
        self.view = MainScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var shortcutActions: [ShortcutAction] = []
        for shortcut in Shortcut.allCases {
            let action = self.actionForShortcut(shortcut)
            shortcutActions.append(.init(
                item: shortcut.item,
                action: action
            ))
        }

        self.shortcutsController = ShortcutsController(
            shortcutActions: shortcutActions
        )

        self.rootView.bottomBar.settingsButton.target = self
        self.rootView.bottomBar.settingsButton.action = #selector(self.settingAction)

        self.rootView.bottomBar.shortcutsButton.target = self
        self.rootView.bottomBar.shortcutsButton.action = #selector(self.shortcutAction)
    }

    @objc func settingAction() {
        (NSApplication.shared.delegate as? AppDelegate)?.windowManager.activateWindowIfNeeded(.settings)
    }

    @objc func shortcutAction() {
        print("Shortcut")
    }

    func actionForShortcut(_ shortcut: Shortcut) -> VoidBlock? {
        switch shortcut {
        case .nextItem:
            return { [weak self] in
                self?.rootView.mainContentView.selectNext(
                    nextSection: false
                )
            }
        case .preveousItem:
            return { [weak self] in
                self?.rootView.mainContentView.selectPreveous(
                    nextSection: false
                )
            }
        case .nextSection:
            return { [weak self] in
                self?.rootView.mainContentView.selectNext(
                    nextSection: true
                )
            }
        case .preveousSection:
            return { [weak self] in
                self?.rootView.mainContentView.selectPreveous(
                    nextSection: true
                )
            }
        case .deleteItem:
            return { [weak self] in
                self?.rootView.mainContentView.deleteActiveItemAction()
            }
        case .previewItem:
            return { [weak self] in
                self?.rootView.spaceClicked()
            }
        case .complete:
            return { [weak self] in
                self?.rootView.mainContentView.completeActiveItemAction()
            }
        }
    }

    // MARK: - Show/Hide

    func show() {
        self.rootView.show()
        self.shortcutsController?.start()
    }

    func hide(completion: VoidBlock?) {
        self.rootView.hide(completion: completion)
        self.shortcutsController?.stop()
    }

    // MARK: - Shorcuts

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return self.shortcutsController?.performKeyEquivalent(with: event) ?? true
    }

    override func insertText(_ insertString: Any) {
        if self.shortcutsController?.insertText(insertString) == false {
            super.insertText(insertString)
        }
    }
}
