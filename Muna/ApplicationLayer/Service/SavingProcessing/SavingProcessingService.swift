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
        var savingType: SavingType
        var dueDateString: String?
        var date: Date?
        var comment: String?
    }

    private var image: NSImage?

    private let database: ItemsDatabaseServiceProtocol
    private let dueDateTextService: DueDateTextServiceProtocol

    init(
        database: ItemsDatabaseServiceProtocol,
        dueDateTextService: DueDateTextServiceProtocol
    ) {
        self.database = database
        self.dueDateTextService = dueDateTextService
    }

    func addImage(_ image: NSImage) {
        self.image = image
    }

    func save(withItem item: ItemToSave, byShortcut: Bool) {
        // FUTURE: Do in background
        // FUTURE: Add quaility selection in settings
        var convertedData: Data?

        switch item.savingType{
        case .screenshot:
            guard let image = self.image,
                  let data = image.tiffRepresentation(using: .jpeg, factor: 0.83)
            else {
                appAssertionFailure("Image is not provided")
                return
            }

            let options = NSMutableDictionary()
            options.setValue(true as NSNumber, forKey: kCGImageSourceCreateThumbnailWithTransform as String)
            options.setValue(2460 as NSNumber, forKey: kCGImageSourceThumbnailMaxPixelSize as String)
            options.setValue(true as NSNumber, forKey: kCGImageSourceCreateThumbnailFromImageAlways as String)

            var imageData: Data?
            if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
                let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
                if let image = image, let data = NSImage(cgImage: image, size: image.backingSize).tiffRepresentation(using: .jpeg, factor: 0.83) {
                    let imageRep = NSBitmapImageRep(data: data)
                    imageData = imageRep?.representation(using: .jpeg, properties: [:])
                }
            }

            guard let covertedData = imageData else {
                appAssertionFailure("Can't comress")
                return
            }
            convertedData = covertedData
        case .text:
            break
        }

        let itemModel = self.database.addItem(
            imageData: convertedData,
            savingType: item.savingType,
            dueDateString: item.dueDateString,
            dueDate: item.date,
            comment: item.comment
        )
        self.dueDateTextService.newItemCreated(dueDateUsed: item.date != nil)
        self.image = nil

        if let itemModel = itemModel {
            ServiceLocator.shared.notifications.sheduleNotification(
                item: itemModel
            )
        }

        var properties: [String: AnalyticsValueProtocol] = [:]
        if let date = item.date, let dueDateString = item.dueDateString {
            properties["due_date"] = date.toFormat("dd MMM yyyy HH:mm")
            properties["current_date"] = Date().toFormat("dd MMM yyyy HH:mm")
            properties["due_date_string"] = dueDateString
            properties["by_shortcut"] = byShortcut
        }
        properties["item_type"] = item.savingType.rawValue

        ServiceLocator.shared.analytics.increasePersonProperty(
            name: "number_of_created_items",
            by: 1
        )

        ServiceLocator.shared.analytics.logEvent(
            name: "Item Created",
            properties: properties
        )

        ServiceLocator.shared.analytics.executeControl(
            control: .itemCreate,
            byShortcut: byShortcut
        )
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

public extension CGImage {
    var backingSize: NSSize {
        return NSSize(width: width / 2, height: height / 2)
    }
}
