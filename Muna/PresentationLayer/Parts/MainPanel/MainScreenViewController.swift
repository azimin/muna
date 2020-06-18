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
            shortcutActions.append(.init(
                item: shortcut.item,
                action: { [weak self] in
                    self?.actionForShortcut(shortcut)
                }
            ))
        }

        self.shortcutsController = ShortcutsController(
            shortcutActions: shortcutActions
        )

        self.rootView.shortcutsView.closeButton.target = self
        self.rootView.shortcutsView.closeButton.action = #selector(self.shortcutAction)

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
        self.showShortcutsView()
    }

    func actionForShortcut(_ shortcut: Shortcut) {
        switch shortcut {
        case .nextItem:
            self.panelView.mainContentView.selectNext(
                nextSection: false
            )
        case .preveousItem:
            self.panelView.mainContentView.selectPreveous(
                nextSection: false
            )
        case .nextSection:
            self.panelView.mainContentView.selectNext(
                nextSection: true
            )
        case .preveousSection:
            self.panelView.mainContentView.selectPreveous(
                nextSection: true
            )
        case .deleteItem:
            self.panelView.mainContentView.deleteActiveItemAction()
        case .previewItem:
            self.panelView.spaceClicked()
        case .complete:
            self.panelView.mainContentView.completeActiveItemAction()
        case .editTime:
            self.panelView.mainContentView.editReminder()
        case .close:
            ServiceLocator.shared.windowManager.hideWindowIfNeeded(.panel(selectedItem: nil))
        }
    }

    // MARK: - Show/Hide

    func show(selectedItem: ItemModel? = nil) {
        self.view.window?.makeFirstResponder(self.view)

        self.panelView.show(selectedItem: selectedItem)
        self.shortcutsController?.start()
    }

    func showShortcutsView() {
        self.view.window?.makeFirstResponder(self.view)

        self.rootView.toggleShortutsView()
    }

    func toggle(selectedItem: ItemModel? = nil) {
        self.panelView.toggle(selectedItem: selectedItem)
    }

    func hide(completion: VoidBlock?) {
        self.panelView.hide(completion: completion)
        self.rootView.hideShortcutsView()
        self.rootView.hideChangeTimeView()

        self.shortcutsController?.stop()
    }

    // MARK: - Shorcuts

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if self.shortcutsController?.performKeyEquivalent(with: event) == true {
            return true
        } else {
            return super.performKeyEquivalent(with: event)
        }
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
