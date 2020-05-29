//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/3/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class MainPanelContentView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout, PopUpControllerDelegate {
    private let headerHight: CGFloat = 28
    private let insetsForSection = NSEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

    let scrollView = StopableScrollView()
    let collectionView = NSCollectionView()
    let segmentControl = NSSegmentedControl()

    var selectedFilter: ItemsDatabaseService.Filter = .uncompleted
    var groupedData = PanelItemModelGrouping(
        items: ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted)
    )

    let popUpController = PopUpController()
    let emptyStateView = EmptyStateView()

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.popUpController.delegate = self

        self.scrollView.documentView = self.collectionView
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.addSubview(self.emptyStateView)
        self.emptyStateView.snp.makeConstraints { maker in
            maker.width.equalTo(WindowManager.panelWindowFrameWidth - 32)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }

        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 24

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = layout
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.backgroundColors = [.clear]
        self.collectionView.isSelectable = true

        self.selectFirstIndexIfNeeded()
        self.updateState()

        self.collectionView.registerReusableCellWithClass(
            GenericCollectionViewItem<MainPanelItemView>.self
        )

        self.collectionView.registerReusableHeaderClass(
            MainPanelHeaderView.self
        )

        if let contentSize = self.collectionView.collectionViewLayout?.collectionViewContentSize {
            self.collectionView.setFrameSize(contentSize)
        }
    }

    func switchContent(filter: ItemsDatabaseService.Filter) {
        self.selectedFilter = filter
        self.groupedData = PanelItemModelGrouping(
            items: ServiceLocator.shared.itemsDatabase.fetchItems(filter: filter)
        )
        self.collectionView.reloadData()
        self.updateState()

        self.selectFirstIndexIfNeeded()
        self.scrollView.contentView.scroll(to: .zero)
    }

    func reloadData(selectedItem: ItemModel? = nil) {
        var selectedIndexPath = self.collectionView.selectionIndexPaths.first

        if let item = selectedItem, let filter = ServiceLocator.shared.itemsDatabase.itemFilter(by: item.id) {
            self.selectedFilter = filter
        }

        self.groupedData = PanelItemModelGrouping(
            items: ServiceLocator.shared.itemsDatabase.fetchItems(filter: self.selectedFilter)
        )
        self.collectionView.reloadData()
        self.updateState()

        let animated: Bool

        if let item = selectedItem,
            let indexPath = self.groupedData.indexPath(for: item) {
            selectedIndexPath = indexPath
            animated = true
        } else {
            animated = false
        }

        if let indexPath = selectedIndexPath {
            self.select(indexPath: indexPath, animated: animated)
        } else {
            self.select(indexPath: .init(item: 0, section: 0), animated: false)
        }
    }

    func updateState() {
        self.emptyStateView.isHidden = self.groupedData.totalNumberOfItems > 0
        switch self.selectedFilter {
        case .noDeadline:
            self.emptyStateView.update(style: .noDeadline)
        case .uncompleted:
            self.emptyStateView.update(style: .noUncompletedItems(shortcut: .init(
                key: .s,
                modifiers: [.command, .shift]
            )))
        case .completed:
            self.emptyStateView.update(style: .noCompletedItems)
        default:
            assertionFailure("Not supported")
            self.emptyStateView.update(style: .noUncompletedItems(shortcut: nil))
        }
    }

    private func selectFirstIndexIfNeeded() {
        self.select(indexPath: .init(item: 0, section: 0), animated: false)
    }

    private func select(indexPath: IndexPath, animated: Bool) {
        if self.collectionView.numberOfSections > indexPath.section, self.collectionView.numberOfItems(inSection: indexPath.section) > indexPath.item {
            if animated {
                self.selectIndexPath(
                    indexPath: indexPath,
                    completion: nil
                )
            } else {
                self.collectionView.selectItems(
                    at: .init(arrayLiteral: indexPath),
                    scrollPosition: .left
                )
            }
        } else if self.collectionView.numberOfSections > 0, self.collectionView.numberOfItems(inSection: 0) > 0 {
            self.collectionView.selectItems(
                at: .init(arrayLiteral: IndexPath(item: 0, section: 0)),
                scrollPosition: .left
            )
        }
    }

    var capturedView: NSView?
    var capturedItem: ItemModel?

    override func rightMouseUp(with event: NSEvent) {
        let point = self.window?.contentView?.convert(event.locationInWindow, to: self.collectionView) ?? .zero

        if let item = self.cellAt(point: point),
            let indexPath = self.collectionView.indexPath(for: item) {
            self.selectIndexPath(indexPath: indexPath, completion: nil)

            let itemModel = self.groupedData.item(at: indexPath)

            self.capturedView = item.view
            self.capturedItem = itemModel

            let menu = NSMenu(title: "ControlMenu")

            let completeItem = NSMenuItem(
                title: itemModel.isComplited ? "Uncomplete" : "Complete",
                action: #selector(self.completeActiveItemAction),
                keyEquivalent: "↩"
            )
            completeItem.keyEquivalentModifierMask = []

            let previewItem = NSMenuItem(title: "Preview Image", action: #selector(self.previewAction), keyEquivalent: "␣")
            previewItem.keyEquivalentModifierMask = []

            let deleteItem = NSMenuItem(title: "Delete", action: #selector(self.deleteActiveItemAction), keyEquivalent: "⌫")
            deleteItem.keyEquivalentModifierMask = []

            menu.addItem(completeItem)
            menu.addItem(previewItem)
            menu.addItem(deleteItem)
            NSMenu.popUpContextMenu(menu, with: event, for: item.view)
        } else {
            return super.rightMouseUp(with: event)
        }
    }

    @objc func previewAction() {
        self.popUpController.show()
    }

    @objc
    func completeActiveItemAction() {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("No selected index")
            return
        }

        let item = self.groupedData.item(at: indexPath)
        item.isComplited.toggle()

        self.selectIndexPath(indexPath: indexPath, completion: nil)
    }

    @objc
    func deleteActiveItemAction() {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("No selected index")
            return
        }

        self.selectIndexPath(indexPath: indexPath, completion: {
            let item = self.groupedData.item(at: indexPath)
            ServiceLocator.shared.itemsDatabase.removeItem(id: item.id)
            self.reloadData()
        })
    }

    var popover: NSPopover?

    var isPopOverShown: Bool {
        return self.popover?.isShown == true
    }

    func togglePopOver() {
        if self.popover == nil || self.popover?.isShown == false {
            self.showPopOver()
        } else {
            self.popover?.close()
        }
    }

    @objc
    func showPopOver() {
        self.popover?.close()
        self.popover = nil

        guard let capturedView = self.capturedView,
            let capturedItem = self.capturedItem else {
            assertionFailure("No captured view")
            return
        }

        guard let screeSize = self.window?.screen?.frame else {
            assertionFailure("No screen size")
            return
        }

        guard let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: capturedItem.imageName) else {
            assertionFailure("No image")
            return
        }

        let popover = NSPopover()

        popover.contentViewController = ImagePreviewViewController(
            image: image,
            maxSize: CGSize(
                width: screeSize.width * 0.5,
                height: screeSize.height * 0.8
            )
        )
        popover.behavior = .semitransient
        popover.animates = true

        popover.show(
            relativeTo: capturedView.frame,
            of: self.collectionView,
            preferredEdge: .minX
        )

        self.popover = popover
        self.popUpController.popover = popover
    }

    func cellAt(point: NSPoint) -> NSCollectionViewItem? {
        for cell in self.collectionView.visibleItems() {
            // swiftlint:disable legacy_nsgeometry_functions
            if NSPointInRect(point, cell.view.frame) {
                return cell
            }
        }

        return nil
    }

    func popUpOnSelectedItem(forceShow: Bool) {
        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("No selected index")
            return
        }

        self.selectIndexPath(indexPath: indexPath, completion: {
            guard let item = self.collectionView.item(at: indexPath) else {
                assertionFailure("No item")
                return
            }
            self.capturedView = item.view
            self.capturedItem = self.groupedData.item(at: indexPath)

            if forceShow {
                self.showPopOver()
            } else {
                self.togglePopOver()
            }
        })
    }

    // MARK: - Preveous/Next

    func selectPreveous(nextSection: Bool) {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let preveous = self.collectionView.preveousIndexPath(
            indexPath: value,
            nextSection: nextSection
        ) {
            if self.collectionView.selectionIndexPaths.first == preveous {
                return
            }
            self.scrollView.stopScroll()
            self.selectIndexPath(indexPath: preveous, completion: nil)
        }

        self.popUpController.hideAndAddShowToQueueIfNeeded()
    }

    func selectNext(nextSection: Bool) {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let next = self.collectionView.nextIndexPath(
            indexPath: value,
            nextSection: nextSection
        ) {
            if self.collectionView.selectionIndexPaths.first == next {
                return
            }
            self.scrollView.stopScroll()
            self.selectIndexPath(indexPath: next, completion: nil)
        }

        self.popUpController.hideAndAddShowToQueueIfNeeded()
    }

    var selectedIndex: IndexPath?

    func selectIndexPath(indexPath: IndexPath, completion: VoidBlock?) {
        self.collectionView.deselectItems(at: self.collectionView.selectionIndexPaths)

        self.selectedIndex = indexPath

        let cell = self.collectionView.item(at: indexPath)
        var cellFrame: CGRect?

        var shouldScroll = cell == nil
        if let cellItem = cell {
            let visibleFrame = CGRect(
                x: self.scrollView.documentVisibleRect.minX,
                y: self.scrollView.documentVisibleRect.minY,
                width: self.scrollView.frame.width,
                height: self.scrollView.frame.height
            )

            cellFrame = cellItem.view.frame
            shouldScroll = visibleFrame.intersectionPercentage(cellItem.view.frame) < 100
        }

        var frameToScroll: CGRect?
        if var frame = cellFrame {
            if indexPath.item == 0 {
                let topInset = self.insetsForSection.top + self.insetsForSection.bottom + self.headerHight
                frame.origin.y -= topInset
                frame.size.height += topInset
            } else {
                frame.origin.y -= self.insetsForSection.top
                frame.size.height += self.insetsForSection.top
            }
            frame.size.height += self.insetsForSection.bottom
            frameToScroll = frame
        }

        if shouldScroll {
            if let frame = frameToScroll {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0.15
                NSAnimationContext.current.allowsImplicitAnimation = true
                NSAnimationContext.current.completionHandler = {
                    completion?()
                }
                self.collectionView.selectItems(
                    at: Set<IndexPath>.init(arrayLiteral: indexPath),
                    scrollPosition: .left
                )
                self.collectionView.animator().scrollToVisible(frame)
                NSAnimationContext.endGrouping()
            } else {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0.15
                NSAnimationContext.current.allowsImplicitAnimation = true
                NSAnimationContext.current.completionHandler = {
                    completion?()
                    if let indexPath = self.selectedIndex {
                        self.selectIndexPath(indexPath: indexPath, completion: nil)
                    }
                }
                self.collectionView.animator().selectItems(
                    at: Set<IndexPath>.init(arrayLiteral: indexPath),
                    scrollPosition: .nearestHorizontalEdge
                )
                NSAnimationContext.endGrouping()
            }
        } else {
            self.collectionView.selectItems(
                at: Set<IndexPath>.init(arrayLiteral: indexPath),
                scrollPosition: .left
            )
            if let frame = frameToScroll {
                self.collectionView.scrollToVisible(frame)
            }
            completion?()
        }
    }

    // MARK: - PopUpControllerDelegate

    func popUpControllerAskToHide(_ popUpController: PopUpController) {
        self.popover?.close()
    }

    func popUpControllerAskToShowCurrentItem(_ popUpController: PopUpController) {
        self.popUpOnSelectedItem(forceShow: true)
    }

    // MARK: - NSCollectionViewDataSource

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.groupedData.sections
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupedData.numberOfItems(in: section)
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind,
        at indexPath: IndexPath
    ) -> NSView {
        guard kind == NSCollectionView.elementKindSectionHeader else {
            return NSView()
        }

        let header = collectionView.dequeueReusableHeaderCellWithType(
            MainPanelHeaderView.self,
            indexPath: indexPath
        )
        let group = self.groupedData.group(in: indexPath.section)
        header.label.stringValue = group.rawValue
        header.redArrowView.isHidden = group != .passed

        return header
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.dequeueReusableCellWithType(
            GenericCollectionViewItem<MainPanelItemView>.self,
            indexPath: indexPath
        )

        let item = self.groupedData.item(at: indexPath)
        cell.customSubview.update(item: item)

        return cell
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> NSSize {
        if section == 0 {
            return NSSize(
                width: collectionView.frame.size.width,
                height: self.headerHight + 16
            )
        } else {
            return NSSize(
                width: collectionView.frame.size.width,
                height: self.headerHight
            )
        }
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        insetForSectionAt section: Int
    ) -> NSEdgeInsets {
        return self.insetsForSection
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(
            width: collectionView.frame.size.width,
            height: 250
        )
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let value = indexPaths.first {
            self.selectIndexPath(indexPath: value, completion: nil)
        }
    }
}
