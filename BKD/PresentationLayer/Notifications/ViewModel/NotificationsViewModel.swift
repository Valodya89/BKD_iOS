//
//  NotificationsViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 02-01-22.
//

import UIKit

final class NotificationsViewModel {
    
    ///Get selected all notifications
    func selectAllNotifications(notifications: [NotificationModel]?) -> [NotificationModel]? {
        var selectNotifications = notifications
        guard let notifs = selectNotifications else {return nil}
        for i in 0 ..< notifs.count {
            selectNotifications![i].isSelect = true
        }
        return selectNotifications
    }
    
    ///Get unselected all notifications
    func unselectAllNotifications(notifications: [NotificationModel]?) -> [NotificationModel]? {
        var selectNotifications = notifications
        guard let notifs = selectNotifications else {return nil}
        for i in 0 ..< notifs.count {
            selectNotifications![i].isSelect = false
        }
        return selectNotifications
    }
    
    ///Delete selected notifications
    func deleteNotifications(notifications: [NotificationModel]?) -> [NotificationModel]? {
        var selectNotifications = notifications
        guard let _ = notifications else {return nil}
     
        selectNotifications?.removeAll(where: {$0.isSelect == true })
        return selectNotifications
    }
}
