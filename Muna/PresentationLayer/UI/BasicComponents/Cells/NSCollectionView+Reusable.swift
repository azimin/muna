//
//  NSCollectionView+Reusable.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

public typealias MunaCollectionViewCell = NSCollectionViewItem & ReusableView
public typealias MunaCollectionHeaderView = NSView & ReusableView

extension NSCollectionView {
    public func registerReusableCellWithClass<T: MunaCollectionViewCell>(_ cellType: T.Type) {
        self.register(
            cellType,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellType.reuseIdentifier)
        )
    }

    public func registerAnonimusReusableCellWithClass(_ anonimusCellType: MunaCollectionViewCell.Type) {
        self.register(
            anonimusCellType,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: anonimusCellType.reuseIdentifier)
        )
    }

    public func dequeueReusableCellWithType<T: MunaCollectionViewCell>(_ viewType: T.Type, indexPath: IndexPath) -> T {
        return self.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: viewType.reuseIdentifier),
            for: indexPath
        ) as! T
    }

    public func registerReusableHeaderClass<T: MunaCollectionHeaderView>(_ cellType: T.Type) {
        self.register(
            cellType,
            forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellType.reuseIdentifier
            )
        )
    }

    public func dequeueReusableHeaderCellWithType<T: MunaCollectionHeaderView>(_ viewType: T.Type, indexPath: IndexPath) -> T {
        return self.makeSupplementaryView(
            ofKind: NSCollectionView.elementKindSectionHeader,
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: viewType.reuseIdentifier),
            for: indexPath
            ) as! T
    }
}
