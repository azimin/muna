//
//  SavingProcessingService.swift
//  Muna
//
//  Created by Egor Petrov on 13.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import CoreGraphics

class SavingProcessingService {
    struct ItemToSave {
        var dueDateString: String?
        var date: Date?
        var comment: String?
    }

    private var image: NSImage?

    private let database: ItemsDatabaseServiceProtocol

    init(database: ItemsDatabaseServiceProtocol) {
        self.database = database
    }

    func addImage(_ image: NSImage) {
        self.image = image
    }

    func save(withItem item: ItemToSave) {
        guard let image = self.image else {
            assertionFailure("Image is not provided")
            return
        }

//        guard let data = image.tiffRepresentation(using: .jpeg, factor: 0.6),
//            let imageRep = NSBitmapImageRep(data: data),
//            let compressedData = imageRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:]),
//            let compressedImage = NSImage(data: compressedData) else {
//            assertionFailure("Can't compress image")
//            return
//        }
//
//        print("Size", image.size, compressedImage.size)

        let itemModel = self.database.addItem(
            image: image,
            dueDateString: item.dueDateString,
            dueDate: item.date,
            comment: item.comment
        )
        self.image = nil

        if let itemModel = itemModel {
            ServiceLocator.shared.notifications.sheduleNotification(
                item: itemModel
            )
        }
    }
}

private extension NSImage {
    func compressedJPEG(with factor: Double) -> Data? {
        guard let tiff = tiffRepresentation else { return nil }
        guard let imageRep = NSBitmapImageRep(data: tiff) else { return nil }

        let options: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: factor,
        ]

        return imageRep.representation(using: .jpeg, properties: options)
    }
}
