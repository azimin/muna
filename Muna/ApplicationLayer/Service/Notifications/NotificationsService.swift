//
//  NotificationsService.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate
import UserNotifications

protocol NotificationsServiceProtocol {
    func sheduleNotification(item: ItemModelProtocol)
    func sheduleNotification(item: ItemModelProtocol, offset: TimeInterval, onlyIfMissing: Bool)

    func cleanUpNotifications()
    func removeNotification(item: ItemModelProtocol)
}

class NotificationsService: NotificationsServiceProtocol {
    func sheduleNotification(item: ItemModelProtocol) {
        self.sheduleNotification(item: item, offset: 0, onlyIfMissing: false)
    }

    func sheduleNotification(item: ItemModelProtocol, offset: TimeInterval, onlyIfMissing: Bool) {
        if onlyIfMissing {
            self.alreadyPending(item: item) { isPending in
                print("Is pending: \(isPending)")
                if isPending == false {
                    if #available(OSX 10.15, *) {
                        self.sheduleNotification(item: item, offset: offset)
                    } else {
                        self.sheduleNotificationOld(item: item, offset: offset)
                    }
                }
            }
        } else {
            if #available(OSX 10.15, *) {
                self.sheduleNotification(item: item, offset: offset)
            } else {
                self.sheduleNotificationOld(item: item, offset: offset)
            }
        }
    }

    private func sheduleNotificationOld(item: ItemModelProtocol, offset: TimeInterval) {
        guard let dueDate = item.dueDate else {
            return
        }

        let timeInterval: TimeInterval = dueDate.timeIntervalSinceNow + offset
        guard timeInterval > 0 else {
            return
        }

        let newDueDate = Date(timeIntervalSinceNow: timeInterval)

        let notification = NSUserNotification()
        notification.title = "Muna"
        notification.subtitle = "Time to check pending items"

        if let comment = item.comment, comment.isEmpty == false {
            notification.informativeText = comment
        }
        notification.identifier = item.notificationId
        notification.userInfo = ["item_id": item.id]
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = newDueDate
        notification.hasActionButton = true
        notification.actionButtonTitle = "Preview"

        NSUserNotificationCenter.default.scheduleNotification(notification)
        print(NSUserNotificationCenter.default.scheduledNotifications)
    }

    func cleanUpNotifications() {
        guard #available(OSX 10.15, *) else {
            return
        }

        let items = ServiceLocator.shared.itemsDatabase.fetchItems(filter: .all)

        AppDelegate.notificationCenter.getDeliveredNotifications { notifications in
            var identifiersToRemove: [String] = []
            for notification in notifications {
                let identifier = notification.request.identifier
                if let item = items.first(where: { $0.notificationId == identifier }) {
                    if item.isComplited {
                        identifiersToRemove.append(identifier)
                    }

                    if let date = item.dueDate, date.isInFuture {
                        identifiersToRemove.append(identifier)
                    }
                } else {
                    identifiersToRemove.append(identifier)
                }
            }

            AppDelegate.notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
        }
    }

    private func sheduleNotification(item: ItemModelProtocol, offset: TimeInterval) {
        guard let dueDate = item.dueDate else {
            return
        }

        let timeInterval: TimeInterval = dueDate.timeIntervalSinceNow + offset
        guard timeInterval > 0 else {
            return
        }

        let notificationContent = UNMutableNotificationContent()
        if let comment = item.comment, comment.isEmpty == false {
            notificationContent.subtitle = "Time to check pending items"
            notificationContent.body = comment
        } else {
            notificationContent.body = "Time to check pending items"
        }

        notificationContent.categoryIdentifier = "item"
        notificationContent.userInfo = ["item_id": item.id]
        notificationContent.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: item.notificationId,
            content: notificationContent,
            trigger: trigger
        )

        AppDelegate.notificationCenter.add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Notification will trigger at: \(timeInterval)")
            }
        })
    }

    func removeNotification(item: ItemModelProtocol) {
        for item in NSUserNotificationCenter.default.deliveredNotifications.filter({ $0.identifier == item.notificationId }) {
            NSUserNotificationCenter.default.removeDeliveredNotification(item)
        }

        for item in NSUserNotificationCenter.default.scheduledNotifications.filter({ $0.identifier == item.notificationId }) {
            NSUserNotificationCenter.default.removeScheduledNotification(item)
        }

        if #available(OSX 10.15, *) {
            AppDelegate.notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [item.notificationId]
            )

            AppDelegate.notificationCenter.removeDeliveredNotifications(
                withIdentifiers: [item.notificationId]
            )
        }
    }

    private func alreadyPending(item: ItemModelProtocol, completion: @escaping (Bool) -> Void) {
        if #available(OSX 10.15, *) {
            AppDelegate.notificationCenter.getPendingNotificationRequests { request in
                let contains: Bool = request.contains(where: { $0.identifier == item.notificationId })
                if contains {
                    completion(contains)
                } else {
                    AppDelegate.notificationCenter.getDeliveredNotifications { notifications in
                        completion(notifications.contains(where: { $0.request.identifier == item.notificationId }))
                    }
                }
            }
        } else {
            let isPending =
                NSUserNotificationCenter.default.scheduledNotifications.contains(where: { $0.identifier == item.notificationId }) ||
                NSUserNotificationCenter.default.deliveredNotifications.contains(where: { $0.identifier == item.notificationId })
            completion(isPending)
        }
    }
}
