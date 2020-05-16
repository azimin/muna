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
}

class NotificationsService: NotificationsServiceProtocol {
    func sheduleNotification(item: ItemModelProtocol) {
        guard let dueDate = item.dueDate else {
            return
        }

        let notificationContent = UNMutableNotificationContent()

        notificationContent.subtitle = "Time to check pending items"
        notificationContent.body = item.comment ?? ""
        notificationContent.categoryIdentifier = "item"

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

        let timeInterval = dueDate.timeIntervalSince(Date())

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
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
}
