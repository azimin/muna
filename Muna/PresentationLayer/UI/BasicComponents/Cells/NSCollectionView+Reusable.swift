//
//  NSCollectionView+Reusable.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

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
}
