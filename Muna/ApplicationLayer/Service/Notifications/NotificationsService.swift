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

        notificationContent.subtitle = "Time to check pending items"
        notificationContent.body = item.comment ?? ""
        notificationContent.categoryIdentifier = "item"
        notificationContent.userInfo = ["item_id": item.id]

        do {
            let attachement = try UNNotificationAttachment(
                identifier: "image",
                url: ServiceLocator.shared.imageStorage.urlOfImage(name: item.imageName),
                options: nil
            )
            notificationContent.attachments = [attachement]
        } catch {
            print(error)
        }

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: item.notificationId,
            content: notificationContent,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success")
            }
        })
    }

    func removeNotification(item: ItemModelProtocol) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [item.notificationId]
        )
    }
}
