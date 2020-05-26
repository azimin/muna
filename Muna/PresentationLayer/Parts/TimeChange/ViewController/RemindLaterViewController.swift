//
//  RemindLaterViewController.swift
//  Muna
//
//  Created by Alexander on 5/26/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class RemindLaterViewController: NSViewController {
    let taskChangeView: TaskChangeTimeGlobalView

    init(itemModel: ItemModel) {
        self.taskChangeView = TaskChangeTimeGlobalView(
            itemModel: itemModel,
            style: .withImage
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.taskChangeView)
        self.taskChangeView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(40)
            maker.trailing.equalToSuperview().inset(50)
        }
    }
}
