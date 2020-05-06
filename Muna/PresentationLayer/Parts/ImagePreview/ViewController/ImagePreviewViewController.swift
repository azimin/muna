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
    init(image: NSImage) {
        self.image = image
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

        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
