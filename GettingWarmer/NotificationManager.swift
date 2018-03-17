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
    let heaterOn = UNNotificationAction(identifier: "Heat", title: "Heat", options: .foreground)
    let heaterOff = UNNotificationAction(identifier: "Off", title: "Off", options: .foreground)
    let dismiss = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: .destructive)

    func triggerNotification(seconds: TimeInterval, body: String) {
        
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [heaterOn, heaterOff, dismiss],
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
        let identifier = "\(body)NotificationID"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
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
import HomeController
extension NotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("NOTIFICATION did receive notification \(response.actionIdentifier)")
        let identifier = response.actionIdentifier
        if identifier == heaterOn.identifier || identifier == heaterOff.identifier || identifier == UNNotificationDefaultActionIdentifier {
            print("NOTIFICATION turn on the heat")
            let homeController = HomeController()
            homeController.finishedInitializing = {
                for therm in homeController.home.thermostats where therm.canSetThermostatMode()  {
                    print("NOTIFICATION thermostat name is \(therm.name())")
                    

                    if identifier == self.heaterOn.identifier {
                        therm.setMode(to: .heat)
                    }
                    if identifier == self.heaterOff.identifier {
                        therm.setMode(to: .off)
                    }
                    completionHandler()
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present notification")
        completionHandler(.alert)
    }
}
