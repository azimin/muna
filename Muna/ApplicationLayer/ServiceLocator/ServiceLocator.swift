//
//  ServiceLocator.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ServiceLocator {
    static var shared = ServiceLocator()

    let imageStorage: ImageStorageServiceProtocol
    let itemsDatabase: ItemsDatabaseServiceProtocol

    init() {
        self.imageStorage = ImageStorageService()
        self.itemsDatabase = ItemsDatabaseService(imageStorage: self.imageStorage)
    }
}
