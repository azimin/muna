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

    var panelView: MainPanelView {
        return (self.view as! MainScreenView).mainPanelView
    }

    var rootView: MainScreenView {
        return (self.view as! MainScreenView)
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

        self.panelView.bottomBar.settingsButton.target = self
        self.panelView.bottomBar.settingsButton.action = #selector(self.settingAction)

        self.panelView.bottomBar.shortcutsButton.target = self
        self.panelView.bottomBar.shortcutsButton.action = #selector(self.shortcutAction)

        self.panelView.mainContentView.delegate = self
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
                self?.panelView.mainContentView.selectNext(
                    nextSection: false
                )
            }
        case .preveousItem:
            return { [weak self] in
                self?.panelView.mainContentView.selectPreveous(
                    nextSection: false
                )
            }
        case .nextSection:
            return { [weak self] in
                self?.panelView.mainContentView.selectNext(
                    nextSection: true
                )
            }
        case .preveousSection:
            return { [weak self] in
                self?.panelView.mainContentView.selectPreveous(
                    nextSection: true
                )
            }
        case .deleteItem:
            return { [weak self] in
                self?.panelView.mainContentView.deleteActiveItemAction()
            }
        case .previewItem:
            return { [weak self] in
                self?.panelView.spaceClicked()
            }
        case .complete:
            return { [weak self] in
                self?.panelView.mainContentView.completeActiveItemAction()
            }
        case .editTime:
            return { [weak self] in
                self?.panelView.mainContentView.editReminder()
            }
        }
    }

    // MARK: - Show/Hide

    func show(selectedItem: ItemModel? = nil) {
        self.view.window?.makeFirstResponder(self.view)

        self.panelView.show(selectedItem: selectedItem)
        self.shortcutsController?.start()
    }

    func toggle(selectedItem: ItemModel? = nil) {
        self.panelView.toggle(selectedItem: selectedItem)
    }

    func hide(completion: VoidBlock?) {
        self.panelView.hide(completion: completion)
        self.rootView.hideChangeTimeView()

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

extension MainScreenViewController: MainPanelContentViewDelegate {
    func mainPanelContentViewShouldShowTimeChange(itemModel: ItemModel) {
        self.rootView.showChangeTimeView(
            itemModel: itemModel,
            closeHandler: CloseHandler(close: { [weak self] in
                self?.rootView.hideChangeTimeView()
                self?.shortcutsController?.start()
            })
        )
        self.shortcutsController?.stop()
    }
}
