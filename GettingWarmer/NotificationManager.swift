//
//  NotificationManager.swift
//  GettingWarmer
//
//  Created by Roderic Campbell on 3/6/18.
//  Copyright © 2018 Thumbworks. All rights reserved.
//

import UserNotifications

class NotificationManager: NSObject {
    let categoryIdentifier = "booleanIdentifier"
    let yes = UNNotificationAction(identifier: "Yes", title: "Yes", options: .foreground)
    let no = UNNotificationAction(identifier: "No", title: "No", options: .destructive)
    
    func triggerNotification(seconds: TimeInterval, body: String) {
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [yes, no],
                                              intentIdentifiers: [],
                                              options: [])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let content = UNMutableNotificationContent()
        content.body = body
        content.badge = 3
        content.categoryIdentifier = categoryIdentifier
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        let request = UNNotificationRequest(identifier: "entered region notification", content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("we got an error with a notification \(error)")
            } else {
                print("No error, things went off appropriately")
            }
        }
    }
    
    func authorizeNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: UNAuthorizationOptions.alert) { (success, error) in
            print("error\(String(describing: error)), success\(success)")
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive notification \(response.actionIdentifier)")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present notification")
        completionHandler(.alert)
    }
}
