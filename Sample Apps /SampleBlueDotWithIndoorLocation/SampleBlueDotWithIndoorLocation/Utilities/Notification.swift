//
//  Notification.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import UIKit
import UserNotifications

struct NotificationData {
    let title: String
    let subtitle: String
    let body: String
}

extension Notification {
    
    static func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current()
            .requestAuthorization(options: options) { _, error in
                if let error = error {
                    debugPrint("Error: \(error)")
                }
            }
    }
    
    static func schedule(after time: TimeInterval, payload: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = payload.title
        content.subtitle = payload.subtitle
        content.body = payload.body
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func resetNotificationBadeCount() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
