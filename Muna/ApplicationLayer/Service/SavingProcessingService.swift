//
//  SavingProcessingService.swift
//  Muna
//
//  Created by Egor Petrov on 13.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SavingProcessingService {
    struct ReminderItem {
        let dueDateString: String
        let date: Date
        let comment: String?
    }

    private var image: NSImage?

    private let database: ItemsDatabaseServiceProtocol

    init(database: ItemsDatabaseServiceProtocol) {
        self.database = database
    }

    func addImage(_ image: NSImage) {
        self.image = image
    }

    func save(withItem item: ReminderItem) {
        guard let image = self.image else {
            assertionFailure("Image is not provided")
            return
        }
        self.database.addItem(
            image: image,
            dueDateString: item.dueDateString,
            dueDate: item.date,
            comment: item.comment
        )
        self.image = nil
    }
}
