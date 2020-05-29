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
    let savingService: SavingProcessingService
    let notifications: NotificationsServiceProtocol
    let windowManager: WindowManager

    init() {
        self.imageStorage = ImageStorageService()
        self.notifications = NotificationsService()
        self.itemsDatabase = ItemsDatabaseService(
            imageStorage: self.imageStorage,
            notifications: self.notifications
        )
        self.savingService = SavingProcessingService(database: self.itemsDatabase)
        self.windowManager = WindowManager()
    }
}
