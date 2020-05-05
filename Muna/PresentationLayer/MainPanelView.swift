//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/3/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

typealias VoidBlock = () -> Void

class Panel: NSPanel {
    override var acceptsFirstResponder: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }

    override var canBecomeKey: Bool {
        return true
    }
}

class MainPanelView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {

    let backgroundView = View()
    let visualView = NSVisualEffectView()
    let scrollView = NSScrollView()
    let collectionView = NSCollectionView()

    let groupedData = PanelItemModelGrouping(items: fakeData)

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
        self.collectionView.becomeFirstResponder()
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

    func setup() {
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

    func selectPreveous() {
        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let preveous = self.collectionView.preveousIndexPath(indexPath: value) {
            self.collectionView.deselectItems(at: self.collectionView.selectionIndexPaths)
            self.selectIndexPath(indexPath: preveous)
        }
    }

    func selectNext() {
        guard let value = self.collectionView.selectionIndexPaths.first else {
            assertionFailure("NO index path")
            return
        }

        if let next = self.collectionView.nextIndexPath(indexPath: value) {
            self.collectionView.deselectItems(at: self.collectionView.selectionIndexPaths)
            self.selectIndexPath(indexPath: next)
        }
    }

    func selectIndexPath(indexPath: IndexPath) {
        let cell = collectionView.item(at: indexPath)

        var shouldScroll = cell == nil
        if let cellItem = cell {
            let visibleFrame = CGRect(
                x: self.scrollView.documentVisibleRect.minX,
                y: self.scrollView.documentVisibleRect.minY,
                width: self.scrollView.frame.width,
                height: self.scrollView.frame.height
            )

            shouldScroll = visibleFrame.intersectionPercentage(cellItem.view.frame) < 100
        }

        if shouldScroll {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.3
            NSAnimationContext.current.allowsImplicitAnimation = true
            self.collectionView.animator().selectItems(
                at: Set<IndexPath>.init(arrayLiteral: indexPath),
                scrollPosition: .nearestHorizontalEdge
            )
            NSAnimationContext.endGrouping()
        } else {
            self.collectionView.selectItems(
                at: Set<IndexPath>.init(arrayLiteral: indexPath),
                scrollPosition: .left
            )
        }
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
            height: 28
        )
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        insetForSectionAt section: Int
    ) -> NSEdgeInsets {
        return NSEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {

        return NSSize(
            width: collectionView.frame.size.width,
            height: 250
        )
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {

        if let value = indexPaths.first {
            self.selectIndexPath(indexPath: value)
        }
    }

    override func keyDown(with event: NSEvent) {
        print("Test")
    }
}

extension CGRect {
    func intersectionPercentage(_ otherRect: CGRect) -> CGFloat {
        if !intersects(otherRect) { return 0 }
        let intersectionRect = intersection(otherRect)
        if intersectionRect == self || intersectionRect == otherRect { return 100 }
        let intersectionArea = intersectionRect.width * intersectionRect.height
        let area = width * height
        return (intersectionArea / area) * 100
    }
}
