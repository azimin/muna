//
//  NotificationsService.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

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

        let timeInterval = dueDate.timeIntervalSinceNow + offset
        guard timeInterval > 0 else {
            return
        }

        let newDueDate = Date(timeIntervalSinceNow: timeInterval)

        let notification = NSUserNotification()

        if let comment = item.comment, comment.isEmpty == false {
            notification.subtitle = "Time to check pending items"
            notification.informativeText = comment
        } else {
            notification.subtitle = "Time to check pending items"
        }
        notification.identifier = item.notificationId
        notification.userInfo = ["item_id": item.id]
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = newDueDate

        NSUserNotificationCenter.default.scheduleNotification(notification)
    }

    func removeNotification(item: ItemModelProtocol) {
        for item in NSUserNotificationCenter.default.deliveredNotifications.filter({ $0.identifier == item.notificationId }) {
            NSUserNotificationCenter.default.removeDeliveredNotification(item)
        }

        for item in NSUserNotificationCenter.default.scheduledNotifications.filter({ $0.identifier == item.notificationId }) {
            NSUserNotificationCenter.default.removeScheduledNotification(item)
        }
    }
}
