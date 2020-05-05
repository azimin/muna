//
//  NSCollectionView+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSCollectionView {
    func nextIndexPath(indexPath: IndexPath) -> IndexPath? {
        let section = indexPath.section
        let numberOfItemsInCurrentSection = self.numberOfItems(inSection: section)

        if numberOfItemsInCurrentSection > indexPath.item + 1 {
            return IndexPath(item: indexPath.item + 1, section: section)
        } else if self.numberOfSections <= section + 1 {
            return nil
        } else {
            return self.nextIndexPath(
                indexPath: IndexPath(item: -1, section: section + 1)
            )
        }
    }

    func preveousIndexPath(indexPath: IndexPath) -> IndexPath? {
        let section = indexPath.section

        if section < 0 {
            return nil
        } else if indexPath.item <= 0 {
            if section == 0 {
                return nil
            }

            let numberOfItemsInPreveousSection = self.numberOfItems(inSection: section - 1)

            return self.preveousIndexPath(indexPath:
                IndexPath(
                    item: numberOfItemsInPreveousSection,
                    section: section - 1
                )
            )
        } else {
            return IndexPath(item: indexPath.item - 1, section: section)
        }
    }
}
