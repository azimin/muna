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

final class Cell: NSCollectionViewItem {
    let itemView = MainPanelItemView()

    override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true

        self.view.addSubview(self.itemView)
        self.itemView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}

class MainPanelView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    let backgroundView = View()
    let visualView = NSVisualEffectView()
    let collectionView = NSCollectionView()

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
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

        let scrollView = NSScrollView()
        scrollView.documentView = self.collectionView
        self.backgroundView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
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
        self.collectionView.register(
            Cell.self,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell")
        )

        self.collectionView.registerReusableCellWithClass(GenericCollectionViewItem<MainPanelItemView>.self)

        if let contentSize = self.collectionView.collectionViewLayout?.collectionViewContentSize {
            self.collectionView.setFrameSize(contentSize)
        }
    }

    // MARK: - NSCollectionViewDataSource

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50000
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let cell = collectionView.dequeueReusableCellWithType(
            GenericCollectionViewItem<MainPanelItemView>.self,
            indexPath: indexPath
        )

        cell.customSubview.deadlineLabel.stringValue = "End in: \(indexPath)"
        cell.customSubview.commentLabel.stringValue = "Index: \(indexPath)"
        cell.customSubview.imageView.image =
            NSImage(named: NSImage.Name("img"))

        return cell
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {

        return NSSize(
            width: collectionView.frame.size.width,
            height: 250
        )
    }
}
