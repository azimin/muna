//
//  NSCollectionView+Extensions.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

extension NSCollectionView {
    func nextIndexPath(indexPath: IndexPath, nextSection: Bool) -> IndexPath? {
        let section = indexPath.section
        let numberOfItemsInCurrentSection = self.numberOfItems(inSection: section)

        if nextSection {
            if self.numberOfSections == section + 1 {
                return IndexPath(
                    item: self.numberOfItems(inSection: section) - 1,
                    section: section
                )
            }

            if self.numberOfSections <= section + 1 {
                return nil
            }

            let numberOfItemsInNextSection = self.numberOfItems(inSection: section + 1)

            if numberOfItemsInNextSection == 0 {
                let nextIndexPath = IndexPath(item: 0, section: section + 1)
                return self.nextIndexPath(
                    indexPath: nextIndexPath,
                    nextSection: nextSection
                )
            } else {
                return IndexPath(
                    item: 0,
                    section: section + 1
                )
            }
        }

        if numberOfItemsInCurrentSection > indexPath.item + 1 {
            return IndexPath(item: indexPath.item + 1, section: section)
        } else if self.numberOfSections <= section + 1 {
            return nil
        } else {
            let nextIndexPath = IndexPath(item: -1, section: section + 1)
            return self.nextIndexPath(
                indexPath: nextIndexPath,
                nextSection: nextSection
            )
        }
    }

    func preveousIndexPath(
        indexPath: IndexPath,
        nextSection: Bool
    ) -> IndexPath? {
        let section = indexPath.section

        if section < 0 {
            return nil
        } else if indexPath.item <= 0 {
            if section == 0 {
                return nil
            }

            if nextSection {
                return IndexPath(
                    item: 0,
                    section: section - 1
                )
            }

            let numberOfItemsInPreveousSection = self.numberOfItems(inSection: section - 1)

            let nextIndexPath = IndexPath(
                item: numberOfItemsInPreveousSection,
                section: section - 1
            )

            return self.preveousIndexPath(
                indexPath: nextIndexPath,
                nextSection: nextSection
            )
        } else {
            var newSection = section
            if nextSection, section >= 1, indexPath.item == 0 {
                newSection -= 1
            }

            return IndexPath(
                item: nextSection ? 0 : indexPath.item - 1,
                section: newSection
            )
        }
    }
}
