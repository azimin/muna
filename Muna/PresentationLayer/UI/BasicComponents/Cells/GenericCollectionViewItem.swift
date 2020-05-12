//
//  GenericCollectionViewItem.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class GenericCollectionViewItem<T: NSView>: NSCollectionViewItem, ReusableView where T: GenericCellSubview {
    public let customSubview = T()
    public weak var reusableComponent: ReusableComponent?

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.reusableComponent?.reuse()

        if let reuseView = self.customSubview as? ReusableComponent {
            reuseView.reuse()
        }
    }

    override func loadView() {
        self.view = View()
        self.setup()
    }

    private func setup() {
        self.view.addSubview(self.customSubview)
        self.customSubview.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.customSubview.setSelected(self.isSelected, animated: false)
    }

    public override var isSelected: Bool {
        didSet {
            self.customSubview.setSelected(self.isSelected, animated: false)
        }
    }
}
