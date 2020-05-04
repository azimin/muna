//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/3/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

//class HackedCollectionView: NSCollectionView {
//    override func setFrameSize(_ newSize: NSSize) {
//        let size = collectionViewLayout?.collectionViewContentSize ?? newSize
//        super.setFrameSize(size)
//        if let scrollView = enclosingScrollView {
//            scrollView.hasHorizontalScroller = size.width > scrollView.frame.width
//        }
//    }
//}

final class Cell: NSCollectionViewItem {
  let label = NSText()
  let myImageView = NSImageView()

  override func loadView() {
    self.view = NSView()
    self.view.wantsLayer = true

    self.view.layer?.backgroundColor = NSColor.red.cgColor
  }
}

class MainPanelView: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate {
    let visualView = NSVisualEffectView()
    let collectionView = NSCollectionView()

    override init(frame: NSRect) {
       super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.material = .dark
        self.visualView.state = .active
//        self.visualView.appearance = NSAppearance(named: .vibrantDark)
        self.visualView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        let scrollView = NSScrollView()
        scrollView.documentView = self.collectionView
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(
                NSEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            )
        }

        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.itemSize = NSSize(width: 300, height: 400)

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

        if let contentSize = self.collectionView.collectionViewLayout?.collectionViewContentSize {
            self.collectionView.setFrameSize(contentSize)
        }
    }

    // MARK: - NSCollectionViewDataSource

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
           return 50000
       }

       func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
          withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"),
          for: indexPath
        ) as! Cell

        cell.label.string = "Index: \(indexPath)"
        cell.myImageView.image =
            NSImage(named: NSImage.Name("img"))

        return cell
       }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
        let cell = collectionView.item(at: indexPath) as? Cell else {
          return
      }
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
      guard let indexPath = indexPaths.first,
        let cell = collectionView.item(at: indexPath) as? Cell else {
          return
      }
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {

      return NSSize(
        width: collectionView.frame.size.width,
        height: 40
      )
    }
}
