//
//  ImagePreviewViewController.swift
//  Muna
//
//  Created by Alexander on 5/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ImagePreviewViewController: NSViewController {
    let imageView = ImageView()

    let image: NSImage
    let maxSize: CGSize

    init(image: NSImage, maxSize: CGSize) {
        self.image = image
        self.maxSize = maxSize
        super.init(nibName: nil, bundle: nil)

        self.imageView.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let proportion = self.image.size.height / self.image.size.width

        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.lessThanOrEqualTo(maxSize.width)
            maker.height.lessThanOrEqualTo(maxSize.height)
            maker.height.equalTo(self.imageView.snp.width).multipliedBy(proportion)
        }
    }
}
