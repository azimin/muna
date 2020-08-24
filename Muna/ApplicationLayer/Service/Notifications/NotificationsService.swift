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
                    self.sheduleNotification(item: item, offset: offset)
                }
            }
        } else {
            self.sheduleNotification(item: item, offset: offset)
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

        AppDelegate.notificationCenter.removePendingNotificationRequests(
            withIdentifiers: [item.notificationId]
        )

        AppDelegate.notificationCenter.removeDeliveredNotifications(
            withIdentifiers: [item.notificationId]
        )
    }

    private func alreadyPending(item: ItemModelProtocol, completion: @escaping (Bool) -> Void) {
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
    }
}
