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
    func sheduleNotification(item: ItemModelProtocol, offset: TimeInterval)

    func removeNotification(item: ItemModelProtocol)
}

class NotificationsService: NotificationsServiceProtocol {
    func sheduleNotification(item: ItemModelProtocol) {
        self.sheduleNotification(item: item, offset: 0)
    }

    func sheduleNotification(item: ItemModelProtocol, offset: TimeInterval) {
        guard let dueDate = item.dueDate else {
            return
        }

        let timeInterval = dueDate.timeIntervalSince(Date()) + offset
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
        AppDelegate.notificationCenter.removePendingNotificationRequests(
            withIdentifiers: [item.notificationId]
        )

        AppDelegate.notificationCenter.removeDeliveredNotifications(
            withIdentifiers: [item.notificationId]
        )
    }
}
