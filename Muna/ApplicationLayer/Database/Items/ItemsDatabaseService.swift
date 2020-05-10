//
//  DatabaseService.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ItemsDatabaseServiceProtocol: AnyObject {
    func fetchItems(filter: ItemsDatabaseService.Filter) -> [ItemModel]

    @discardableResult
    func addItem(
        image: NSImage,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?
    ) -> ItemModel?
    func removeItem(id: String)

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

    private var key: String = "ud_main_data_items"
    private let defaults = UserDefaults.standard
    private var items: [ItemModel] = []

    private let imageStorage: ImageStorageServiceProtocol

    init(imageStorage: ImageStorageServiceProtocol) {
        self.imageStorage = imageStorage
        self.loadItems()
    }

    func fetchItems(filter: Filter) -> [ItemModel] {
        switch filter {
        case .all:
            return self.items
        case .uncompleted:
            return self.items.filter { $0.isComplited == false }
        case .completed:
            return self.items.filter { $0.isComplited == true }
        case .noDeadline:
            return self.items.filter { $0.dueDate == nil && $0.isComplited == false }
        }
    }

    func removeItem(id: String) {
        if let index = self.items.firstIndex(where: { $0.id == id }) {
            let item = self.items[index]
            self.items.remove(at: index)

            _ = self.imageStorage.removeImage(name: item.imageName)
        } else {
            assertionFailure("No id")
        }
        self.saveItems()
    }

    @discardableResult
    func addItem(
        image: NSImage,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?
    ) -> ItemModel? {
        let imageName = UUID().uuidString
        guard self.imageStorage.saveImage(image: image, name: imageName) else {
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
            self.imageStorage.removeImage(name: item.imageName)
        }
        UserDefaults.standard.removeObject(forKey: self.key)
        UserDefaults.standard.synchronize()
        self.items = []
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
}

extension ItemsDatabaseService {
    func generateFakeDataIfNeeded(count: Int) {
        self.removeItems()

        for i in 0 ..< count {
            let imageName = "img_\(Int.random(in: 1 ..< 11))"
            self.addItem(
                image: NSImage(named: NSImage.Name(imageName))!,
                dueDateString: "in 2h",
                dueDate: Date().addingTimeInterval(60 * 60 * Double(i)),
                comment: "Hi there"
            )
        }
    }
}
