//
//  DatabaseService.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftDate

protocol ItemsDatabaseServiceProtocol: AnyObject {
    var itemUpdated: Observable<String?> { get }

    func item(by id: String) -> ItemModel?
    func fetchItems(filter: ItemsDatabaseService.Filter) -> [ItemModel]
    func itemFilter(by id: String) -> ItemsDatabaseService.Filter?

    func fetchNumberOfCompletedItems() -> Int
    func changeNumberOfCompletedItems(value: Int)

    @discardableResult
    func addItem(
        imageData: Data,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?
    ) -> ItemModel?
    func removeItem(id: String, shouldTrack: Bool)

    func saveItems()

    func generateFakeDataIfNeeded(count: Int)
}

class ItemsDatabaseService: ItemsDatabaseServiceProtocol {
    enum Filter {
        case all
        case uncompleted
        case noDeadline
        case completed
    }

    let itemUpdated = Observable<String?>(nil)

    private var key: String = "ud_main_data_items"
    private var numberKey: String = "ud_main_data_items_number_of_completed"
    private let defaults = UserDefaults.standard
    private var items: [ItemModel] = []

    private var dateCapturingItems: Preferences.PeriodOfStoring {
        return Preferences.storingPeriod
    }

    private let imageStorage: ImageStorageServiceProtocol
    private let notifications: NotificationsServiceProtocol

    init(
        imageStorage: ImageStorageServiceProtocol,
        notifications: NotificationsServiceProtocol
    ) {
        self.imageStorage = imageStorage
        self.notifications = notifications
        self.loadItems()
    }

    func item(by id: String) -> ItemModel? {
        return self.items.first(where: { $0.id == id })
    }

    func fetchItems(filter: Filter) -> [ItemModel] {
        let items = self.items.filter { $0.isDeleted == false }

        let date = Date()

        let itemsToDelete = self.items.filter { item in
            guard let completionDate = item.completionDate else {
                return false
            }
            let deltaBetweenDates = date.timeIntervalSince1970 - completionDate.timeIntervalSince1970

            switch dateCapturingItems {
            case .day:
                if deltaBetweenDates >= PresentationLayerConstants.oneDayInSeconds {
                    return true
                }
            case .week:
                if deltaBetweenDates >= PresentationLayerConstants.weekInSeconds {
                    return true
                }
            case .month:
                if deltaBetweenDates >= PresentationLayerConstants.oneMonthInSeconds {
                    return true
                }
            case .year:
                if deltaBetweenDates >= PresentationLayerConstants.oneYearInSeconds {
                    return true
                }
            }
            return false
        }
        for item in itemsToDelete {
            self.removeItem(
                id: item.id,
                shouldTrack: false,
                shouldSave: false
            )
        }
        self.items.removeAll { (item) -> Bool in
            itemsToDelete.contains(where: { $0.id == item.id })
        }
        self.saveItems()

        switch filter {
        case .all:
            return items
        case .uncompleted:
            return items.filter { $0.isComplited == false }
        case .completed:
            return items.filter { $0.isComplited == true }
        case .noDeadline:
            return items.filter { $0.dueDate == nil && $0.isComplited == false }
        }
    }

    func itemFilter(by id: String) -> Filter? {
        guard let item = self.items.first(where: { $0.id == id }) else {
            appAssertionFailure("No filter")
            return nil
        }

        if item.isComplited == false {
            return .uncompleted
        } else {
            return .completed
        }
    }

    func removeItem(id: String, shouldTrack: Bool) {
        self.removeItem(id: id, shouldTrack: shouldTrack, shouldSave: true)
    }

    func removeItem(id: String, shouldTrack: Bool, shouldSave: Bool) {
        if let index = self.items.firstIndex(where: { $0.id == id }) {
            let item = self.items[index]
            self.notifications.removeNotification(item: item)
            self.items.remove(at: index)

            if let imageName = item.imageName {
                _ = self.imageStorage.removeImage(name: imageName)
            }

            if shouldTrack {
                ServiceLocator.shared.analytics.increasePersonProperty(
                    name: "number_of_items_deleted",
                    by: 1
                )
            }
        } else {
            appAssertionFailure("No id")
        }

        if shouldSave {
            self.saveItems()
        }
    }

    @discardableResult
    func addItem(
        imageData: Data,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?
    ) -> ItemModel? {
        let imageName = UUID().uuidString
        guard self.imageStorage.saveImage(imageData: imageData, name: imageName) else {
            return nil
        }

        let id = UUID().uuidString
        let item = ItemModel(
            id: id,
            imageName: imageName,
            creationDate: Date(),
            dueDateString: dueDateString,
            dueDate: dueDate,
            comment: comment,
            isComplited: false,
            isNew: true,
            itemsDatabaseService: self
        )
        self.items.append(item)
        self.saveItems()

        return item
    }

    func saveItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            self.defaults.set(encoded, forKey: self.key)
        }
    }

    private func removeItems() {
        for item in self.items {
            if let imageName = item.imageName {
                self.imageStorage.removeImage(name: imageName)
            }
            self.removeItem(id: item.id, shouldTrack: false, shouldSave: false)
        }
        self.saveItems()
    }

    private func loadItems() {
        if let savedItems = defaults.object(forKey: self.key) as? Data {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([ItemModel].self, from: savedItems) {
                self.items = loadedItems
            }
            self.items.forEach { $0.itemsDatabaseService = self }
        }
    }

    // MARK: - Completed items

    func fetchNumberOfCompletedItems() -> Int {
        return self.defaults.int(for: self.numberKey)
    }

    func changeNumberOfCompletedItems(value: Int) {
        let oldValue = self.fetchNumberOfCompletedItems()
        self.defaults.set(oldValue + value, forKey: self.numberKey)
    }
}

extension ItemsDatabaseService {
    func generateFakeDataIfNeeded(count: Int) {
        self.removeItems()

        for i in 0 ..< count {
            let imageName = "img_\(Int.random(in: 1 ..< 11))"
            self.addItem(
                imageData: NSImage(named: NSImage.Name(imageName))!.tiffRepresentation(using: .jpeg, factor: 0.83)!,
                dueDateString: "in 2h",
                dueDate: Date().addingTimeInterval(60 * 60 * Double(i)),
                comment: "Hi there"
            )
        }
    }
}
