//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/3/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

protocol MainPanelContentViewDelegate: AnyObject {
    func mainPanelContentViewShouldShowTimeChange(itemModel: ItemModel)
    func mainPanelContentViewShouldShowCommentChange(itemModel: ItemModel)
}

class MainPanelContentView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout, PopUpControllerDelegate {
    private let headerHight: CGFloat = 39
    private let insetsForSection = NSEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

    let scrollView = StopableScrollView()
    let collectionView = NSCollectionView()
    let segmentControl = NSSegmentedControl()

    var selectedFilter: ItemsDatabaseService.Filter = .uncompleted
    var groupedData = PanelItemModelGrouping(
        items: ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted)
    )

    let popUpController = PopUpController()
    let emptyStateView = EmptyStateView()

    weak var delegate: MainPanelContentViewDelegate?

    private var mouseObservable: ObserverTokenProtocol?

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
        layout.minimumLineSpacing = 8
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

        self.mouseObservable = MousePositionService.shared.mousePosition.observeNewAndCall(self) { mousePoint in
            self.updateMousePoint(mousePoint)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.itemCommentUpdated(notification:)),
            name: Notification.Name("ItemCommentUpdated"),
            object: nil
        )
    }

    @objc
    private func itemCommentUpdated(notification: Notification) {
        guard let item = notification.object as? ItemModel,
              let indexPath = self.groupedData.indexPath(for: item) else {
            return
        }

        self.collectionView.reloadItems(
            at: .init(arrayLiteral: indexPath)
        )

        self.collectionView.selectItems(
            at: .init(arrayLiteral: indexPath),
            scrollPosition: .left
        )
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
            let indexPath = self.groupedData.indexPath(for: item)
        {
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
            self.emptyStateView.update(style: .noUncompletedItems(
                shortcut: Preferences.DefaultItems.defaultScreenshotShortcut.item)
            )
        case .completed:
            self.emptyStateView.update(style: .noCompletedItems)
        default:
            appAssertionFailure("Not supported")
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

    func updateMousePoint(_ point: CGPoint) {
        for cell in self.collectionView.visibleItems() where cell.isSelected {
            if let itemCell = cell as? GenericCollectionViewItem<MainPanelItemView> {
                itemCell.customSubview.passMousePosition(point: point)
            }
        }
    }

    override func rightMouseUp(with event: NSEvent) {
        let point = self.window?.contentView?.convert(event.locationInWindow, to: self.collectionView) ?? .zero

        if let item = self.cellAt(point: point),
            let indexPath = self.collectionView.indexPath(for: item)
        {
            let selectedIndexes = self.collectionView.selectionIndexPaths
            if selectedIndexes.contains(indexPath) == false {
                self.selectIndexPath(indexPath: indexPath, completion: nil)
            }

            let itemModel = self.groupedData.item(at: indexPath)

            self.capturedView = item.view
            self.capturedItem = itemModel

            let menu = NSMenu(title: "ControlMenu")

            let completeItem = NSMenuItem(
                title: itemModel.isComplited ? "Uncomplete" : "Complete",
                action: #selector(self.completeActiveItemActionWithoutShortcut),
                keyEquivalent: "↩"
            )
            completeItem.keyEquivalentModifierMask = []

            let reminderItem = NSMenuItem(
                title: itemModel.dueDate == nil ? "Set Reminder" : "Edit Reminder",
                action: #selector(self.editReminderWithoutShortcut),
                keyEquivalent: "t"
            )
            reminderItem.keyEquivalentModifierMask = [.command]

            let commentItem = NSMenuItem(
                title: (itemModel.comment?.count ?? 0) == 0 ? "Set Comment" : "Edit Comment",
                action: #selector(self.editComment),
                keyEquivalent: ""
            )
            commentItem.keyEquivalentModifierMask = []

            let previewItem = NSMenuItem(title: "Preview Image", action: #selector(self.previewAction), keyEquivalent: "␣")
            previewItem.keyEquivalentModifierMask = []

            let copyItem = NSMenuItem(title: "Copy Image", action: #selector(self.copyActionWithoutShortcut), keyEquivalent: "c")

            let deleteItem = NSMenuItem(title: "Delete", action: #selector(self.deleteActiveItemActionWithoutShortcut), keyEquivalent: "⌫")
            deleteItem.keyEquivalentModifierMask = []

            menu.addItem(completeItem)
            menu.addItem(reminderItem)
            menu.addItem(commentItem)

            if itemModel.savingTypeCasted == .screenshot {
                menu.addItem(NSMenuItem.separator())
                menu.addItem(previewItem)
                menu.addItem(copyItem)
            }

            menu.addItem(NSMenuItem.separator())
            menu.addItem(deleteItem)
            NSMenu.popUpContextMenu(menu, with: event, for: item.view)
        } else {
            return super.rightMouseUp(with: event)
        }
    }

    @objc func previewAction() {
        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            appAssertionFailure("No selected index")
            return
        }

        let item = self.groupedData.item(at: indexPath)

        guard item.savingTypeCasted == .screenshot else {
            return
        }

        ServiceLocator.shared.analytics.executeControl(
            control: .itemPreview,
            byShortcut: false
        )
        self.popUpController.show()
    }

    @objc
    private func copyActionWithoutShortcut() {
        self.copyAction(byShortcut: false)
    }

    @objc func copyAction(byShortcut: Bool) {
        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            appAssertionFailure("No selected index")
            return
        }

        let item = self.groupedData.item(at: indexPath)

        guard item.savingTypeCasted == .screenshot else {
            return
        }

        guard let imageName = item.imageName, let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: imageName) else {
            appAssertionFailure("No image")
            return
        }

        let pb = NSPasteboard.general
        pb.clearContents()
        pb.writeObjects([image])

        ServiceLocator.shared.analytics.executeControl(
            control: .itemCopy,
            byShortcut: byShortcut
        )
    }

    @objc
    private func completeActiveItemActionWithoutShortcut() {
        self.completeActiveItemAction(byShortcut: false)
    }

    @objc
    func completeActiveItemAction(byShortcut: Bool) {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            return
        }

        let item = self.groupedData.item(at: indexPath)
        item.isComplited.toggle()

        self.selectIndexPath(indexPath: indexPath, completion: nil)

        ServiceLocator.shared.analytics.executeControl(
            control: .itemComplete,
            byShortcut: byShortcut
        )
    }

    @objc
    private func editReminderWithoutShortcut() {
        self.editReminder(byShortcut: false)
    }

    func closePopUpIfNeeded() -> Bool {
        let isHidden = self.popUpController.isHidden
        self.popUpController.hide()
        return !isHidden
    }

    @objc
    func editReminder(byShortcut: Bool) {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            appAssertionFailure("No selected index")
            return
        }

        guard let delegate = self.delegate else {
            appAssertionFailure("No delegate")
            return
        }

        let item = self.groupedData.item(at: indexPath)
        delegate.mainPanelContentViewShouldShowTimeChange(itemModel: item)

        ServiceLocator.shared.analytics.executeControl(
            control: .itemEditTime,
            byShortcut: byShortcut
        )
    }

    @objc
    func editComment() {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            appAssertionFailure("No selected index")
            return
        }

        guard let delegate = self.delegate else {
            appAssertionFailure("No delegate")
            return
        }

        let item = self.groupedData.item(at: indexPath)
        delegate.mainPanelContentViewShouldShowCommentChange(itemModel: item)

        ServiceLocator.shared.analytics.executeControl(
            control: .itemEditComment,
            byShortcut: false
        )
    }

    @objc
    private func deleteActiveItemActionWithoutShortcut() {
        self.deleteActiveItemAction(byShortcut: false)
    }

    func deleteActiveItemAction(byShortcut: Bool) {
        guard self.groupedData.totalNumberOfItems > 0 else {
            return
        }

        guard let indexPath = self.collectionView.selectionIndexPaths.first else {
            appAssertionFailure("No selected index")
            return
        }

        self.selectIndexPath(indexPath: indexPath, completion: {
            let item = self.groupedData.item(at: indexPath)

            ServiceLocator.shared.analytics.executeControl(
                control: .itemDelete,
                byShortcut: byShortcut
            )

            ServiceLocator.shared.itemsDatabase.removeItem(
                id: item.id,
                shouldTrack: true
            )
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
            let capturedItem = self.capturedItem
        else {
            appAssertionFailure("No captured view")
            return
        }

        guard capturedItem.savingTypeCasted == .screenshot else {
            return
        }

        guard let screeSize = self.window?.screen?.frame else {
            appAssertionFailure("No screen size")
            return
        }

        guard let imageName = capturedItem.imageName,
              let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: imageName) else {
            appAssertionFailure("No image")
            return
        }

        let popover = NSPopover()

        popover.contentViewController = ImagePreviewViewController(
            image: image,
            maxSize: CGSize(
                width: screeSize.width * 0.65,
                height: screeSize.height * 0.8
            )
        )
        popover.behavior = .semitransient
        popover.animates = true

        popover.show(
            relativeTo: NSRect(x: 0, y: 0, width: 0, height: 0),
            of: capturedView,
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
            return
        }

        self.selectIndexPath(indexPath: indexPath, completion: {
            guard let item = self.collectionView.item(at: indexPath) else {
                appAssertionFailure("No item")
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
        var count = self.groupedData.numberOfItems(in: indexPath.section)

        let additionalSufix: String
        if group == .completed {
            count = ServiceLocator.shared.itemsDatabase.fetchNumberOfCompletedItems()
            additionalSufix = " (including deleted)"
        } else {
            additionalSufix = ""
        }

        let sufix = count == 1 ? "item" : "items"

        header.titleLabel.stringValue = group.rawValue
        header.infoLabel.stringValue = "\(count) \(sufix)\(additionalSufix)"
        header.redArrowView.isHidden = group != .passed

        return header
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.dequeueReusableCellWithType(
            GenericCollectionViewItem<MainPanelItemView>.self,
            indexPath: indexPath
        )

        let item = self.groupedData.item(at: indexPath)

        switch self.selectedFilter {
        case .all, .noDeadline, .uncompleted:
            cell.customSubview.update(item: item, style: .basic)
        case .completed:
            cell.customSubview.update(item: item, style: .completed)
        }

        return cell
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> NSSize {
        let group = self.groupedData.group(in: section)
        if group == .passed || section == 0 {
            return NSSize(
                width: collectionView.frame.size.width,
                height: self.headerHight + 12
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
        let item = self.groupedData.item(at: indexPath)

        let size = NSSize(
            width: collectionView.frame.size.width,
            height: MainPanelItemView.calculateHeight(item: item)
        )
        return size
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let value = indexPaths.first {
            self.selectIndexPath(indexPath: value, completion: nil)
        }
    }
}
