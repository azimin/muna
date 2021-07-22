//
//  ServiceLocator.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ServiceLocator {
    private static let amplitudeId = "fef18005e21e59f8b7252c5bb34708bd"

    static var shared: ServiceLocator!

    var analytics: AnalyticsServiceProtocol
    let imageStorage: ImageStorageServiceProtocol
    let itemsDatabase: ItemsDatabaseServiceProtocol
    let savingService: SavingProcessingService
    let notifications: NotificationsServiceProtocol
    let permissionsService: PermissionsServiceProtocol
    let windowManager: WindowManagerProtocol
    let activeAppCheckService: ActiveAppCheckServiceProtocol
    let assistent: AssistentServiceProtocol
    let inAppPurchaseManager: InAppPurchaseManager

    let securityStorage: StorageServiceProtocol

    let assertionHandler: AssertionHandler

    let backgroundScheduler: BackgroundSchedulerProtocol

    init(assertionHandler: AssertionHandler) {
        self.assertionHandler = assertionHandler
        self.imageStorage = ImageStorageService()
        self.notifications = NotificationsService()
        self.itemsDatabase = ItemsDatabaseService(
            imageStorage: self.imageStorage,
            notifications: self.notifications
        )
        self.savingService = SavingProcessingService(database: self.itemsDatabase)
        self.windowManager = WindowManager()
        self.permissionsService = PermissionsService()
        self.activeAppCheckService = ActiveAppCheckService()
        self.assistent = AssistentService()
        self.analytics = MutedAnalyticsService()

        let inAppReceiptValidationService = InAppRecieptValidationService()
        let inAppPurchaseService = InAppProductPurchaseService()
        let inAppProductsService = InAppProductsService()

        self.backgroundScheduler = BackgroundScheduler()

        #if DEBUG
        self.securityStorage = UserDefaults.standard
        #else
        self.securityStorage = UserDefaults.standard
//        self.securityStorage = SecurityStorage()
        #endif

        self.inAppPurchaseManager = InAppPurchaseManager(
            inAppProductsService: inAppProductsService,
            inAppPurchaseService: inAppPurchaseService,
            inAppRecieptValidationService: inAppReceiptValidationService
        )

        inAppProductsService.requestProducts(forIds: [.monthly, .oneTimeTip], nil)
        
        self.backgroundScheduler.addActivity(
            byKey: .subscriptionValidationTask,
            withConfig: .default
        ) { [weak self] in
            self?.inAppPurchaseManager.validateSubscription(nil)
        }

        self.replaceAnalytics(shouldUseAnalytics: Preferences.shouldUseAnalytics, force: true)
    }

    func replaceAnalytics(shouldUseAnalytics: Bool, force: Bool) {
        if force == false, Preferences.shouldUseAnalytics == shouldUseAnalytics {
            return
        }
        
        Preferences.shouldUseAnalytics = shouldUseAnalytics
        if shouldUseAnalytics {
            var events: [DeferredEvent] = []
            var shouldLogLaunchEvents = false

            if let mutedAnalytics = self.analytics as? MutedAnalyticsService {
                events = mutedAnalytics.events
                shouldLogLaunchEvents = mutedAnalytics.shouldLogLaunchEvents
            }

            self.analytics = AnalyticsService(
                storage: self.securityStorage,
                apmplitudeId: ServiceLocator.amplitudeId,
                additionalServices: []
            )

            if shouldLogLaunchEvents {
                self.analytics.logLaunchEvents()
            }

            for (index, event) in events.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(index)) {
                    switch event.event {
                    case let .event(name, properties):
                        if event.isOnce {
                            self.analytics.logEventOnce(name: name, properties: properties)
                        } else {
                            self.analytics.logEvent(name: name, properties: properties)
                        }
                    case let .personProperty(name, value):
                        if event.isOnce {
                            self.analytics.setPersonPropertyOnce(name: name, value: value)
                        } else {
                            self.analytics.setPersonProperty(name: name, value: value)
                        }
                    case let .incresePersonProperty(name, value):
                        self.analytics.increasePersonProperty(name: name, by: value)
                    }
                }
            }
        } else {
            self.analytics = MutedAnalyticsService()
        }
    }
}
