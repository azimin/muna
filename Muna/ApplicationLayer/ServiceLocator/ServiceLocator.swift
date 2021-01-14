//
//  ServiceLocator.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ServiceLocator {
    static var shared: ServiceLocator!

    let analytics: AnalyticsServiceProtocol
    let imageStorage: ImageStorageServiceProtocol
    let itemsDatabase: ItemsDatabaseServiceProtocol
    let savingService: SavingProcessingService
    let notifications: NotificationsServiceProtocol
    let permissionsService: PermissionsServiceProtocol
    let windowManager: WindowManagerProtocol
    let activeAppCheckService: ActiveAppCheckServiceProtocol
    let assistent: AssistentServiceProtocol
    let betaKey: BetaKeyService
    let inAppPurchaseManager: InAppPurchaseManager

    let assertionHandler: AssertionHandler

    init(assertionHandler: AssertionHandler) {
        self.assertionHandler = assertionHandler
        self.imageStorage = ImageStorageService()
        self.notifications = NotificationsService()
        self.betaKey = BetaKeyService()
        self.itemsDatabase = ItemsDatabaseService(
            imageStorage: self.imageStorage,
            notifications: self.notifications
        )
        self.savingService = SavingProcessingService(database: self.itemsDatabase)
        self.windowManager = WindowManager(betaKey: self.betaKey)
        self.permissionsService = PermissionsService()
        self.activeAppCheckService = ActiveAppCheckService()
        self.assistent = AssistentService()
        self.analytics = AnalyticsService(
            storage: UserDefaults.standard,
            apmplitudeId: "fef18005e21e59f8b7252c5bb34708bd",
            additionalServices: []
        )

        let inAppReceiptValidationService = InAppRecieptValidationService()
        let inAppPurchaseService = InAppProductPurchaseService()
        let inAppProductsService = InAppProductsService()

        self.inAppPurchaseManager = InAppPurchaseManager(
            inAppProductsService: inAppProductsService,
            inAppPurchaseService: inAppPurchaseService,
            inAppRecieptValidationService: inAppReceiptValidationService
        )

        inAppProductsService.requestProducts(forIds: [.monthly], nil)
    }
}
