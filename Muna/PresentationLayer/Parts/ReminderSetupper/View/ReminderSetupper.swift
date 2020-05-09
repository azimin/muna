//
//  ReminderSetupper.swift
//  Muna
//
//  Created by Egor Petrov on 09.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ReminderSetupperDelegate: AnyObject {
    func doneButtonTapped()
}

class ReminderSetupper: NSView {
    weak var delegate: ReminderSetupperDelegate?

    let dateTextField = TextField(fontStyle: .medium, size: 14)
    let commentTextField = TextField(fontStyle: .medium, size: 14)

    let button = Button(
        title: "Done",
        target: self,
        action: #selector(handleDoneButtonTap)
    )

    init(delegate: ReminderSetupperDelegate) {
        self.delegate = delegate

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func handleDoneButtonTap() {
        self.delegate?.doneButtonTapped()
    }
}
