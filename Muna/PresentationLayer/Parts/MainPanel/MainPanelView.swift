//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/3/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

// swiftlint:disable type_body_length
class MainPanelView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout, PopUpControllerDelegate {

    private let headerHight: CGFloat = 28
    private let insetsForSection = NSEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

    let backgroundView = View()
    let visualView = NSVisualEffectView()
    let scrollView = NSScrollView()
    let collectionView = NSCollectionView()

    let groupedData = PanelItemModelGrouping(items: fakeData)

    let popUpController = PopUpController()

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()

        self.window?.makeFirstResponder(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isFirstLanch = true

    override func layout() {
        super.layout()

        if isFirstLanch {
            self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)
            self.isFirstLanch = false
        }
    }

    func setup() {
        self.popUpController.delegate = self

        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.backgroundView.layer?.borderColor = NSColor.gray.cgColor
        self.backgroundView.layer?.borderWidth = 0.5

        self.backgroundView.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.material = .dark
        self.visualView.state = .active
        self.visualView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        self.scrollView.documentView = self.collectionView
        self.backgroundView.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(
                NSEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            )
        }

        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 24

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = layout
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.backgroundColors = [.clear]
        self.collectionView.isSelectable = true

        let itemsToSelect = Set<IndexPath>.init(arrayLiteral: IndexPath(item: 0, section: 0))
        self.collectionView.selectItems(at: itemsToSelect, scrollPosition: .top)

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

    var capturedView: NSView?
    var capturedItem: PanelItemModel?

    override func rightMouseUp(with event: NSEvent) {
        let point = self.convert(event.locationInWindow, to: self.collectionView)

        if let item = self.cellAt(point: point),
            let indexPath = self.collectionView.indexPath(for: item) {

            self.selectIndexPath(indexPath: indexPath, completion: nil)

            self.capturedView = item.view
            self.capturedItem = self.groupedData.item(at: indexPath)
            // TODO: Work with menu
            let menu = NSMenu(title: "ControlMenu")
            menu.addItem(NSMenuItem(title: "Complete", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Preview", action: #selector(self.popUpController.show), keyEquivalent: ""))
            NSMenu.popUpContextMenu(menu, with: event, for: item.view)
        } else {
            return super.rightMouseUp(with: event)
        }
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

        guard let capturedView = self.capturedView,
            let capturedItem = self.capturedItem else {
                assertionFailure("No captured view")
                return
        }

        let popover = NSPopover()
        popover.contentViewController = ImagePreviewViewController(
            image: capturedItem.image
        )
        popover.behavior = .semitransient
        popover.animates = true

        popover.show(
            relativeTo: capturedView.frame,
            of: self.collectionView,
            preferredEdge: .minX
        )

        self.popover = popover
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

    // MARK: - Show/Hide

    func show() {
        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.backgroundView.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(0, 0, 0)
        transform.duration = 0.25

        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(0, 0, 0)
        self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))

        self.addMonitor()
    }

    func hide(completion: VoidBlock?) {
        self.popover?.close()

        CATransaction.begin()
        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.backgroundView.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(self.frame.width, 0, 0)
        transform.duration = 0.25

        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        CATransaction.setCompletionBlock(completion)
        self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))
        CATransaction.commit()
    }

    var downMonitor: Any?

    func addMonitor() {
        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in

            // up
            if event.keyCode == 126 {
                self.selectPreveous()
                return nil
                // down
            } else if event.keyCode == 125 {
                self.selectNext()
                return nil
            }

            return event
        })
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // esc
        if event.keyCode == 53 {
            (NSApplication.shared.delegate as? AppDelegate)?.hidePanelIfNeeded()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }

    override func insertText(_ insertString: Any) {
        if let string = insertString as? String, string == " " {
            self.popUpController.toggle()
        } else {
            super.insertText(insertString)
        }
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

    func selectPreveous() {
        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let preveous = self.collectionView.preveousIndexPath(indexPath: value) {
            if self.collectionView.selectionIndexPaths.first == preveous {
                return
            }
            self.selectIndexPath(indexPath: preveous, completion: nil)
        }

        self.popUpController.hideAndAddShowToQueueIfNeeded()
    }

    func selectNext() {
        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let next = self.collectionView.nextIndexPath(indexPath: value) {
            if self.collectionView.selectionIndexPaths.first == next {
                return
            }
            self.selectIndexPath(indexPath: next, completion: nil)
        }

        self.popUpController.hideAndAddShowToQueueIfNeeded()
    }

    var selectedIndex: IndexPath?

    func selectIndexPath(indexPath: IndexPath, completion: VoidBlock?) {
        self.collectionView.deselectItems(at: self.collectionView.selectionIndexPaths)

        self.selectedIndex = indexPath

        let cell = collectionView.item(at: indexPath)
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
        at indexPath: IndexPath) -> NSView {
        guard kind == NSCollectionView.elementKindSectionHeader else {
            return NSView()
        }

        let header = collectionView.dequeueReusableHeaderCellWithType(
            MainPanelHeaderView.self,
            indexPath: indexPath
        )
        let group = self.groupedData.group(in: indexPath.section)
        header.label.stringValue = group.rawValue
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
        referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(
            width: collectionView.frame.size.width,
            height: self.headerHight
        )
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
