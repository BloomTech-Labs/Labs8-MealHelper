//
//  LocalNotifications.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 29/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper
{
    let center = UNUserNotificationCenter.current()
    
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            // Adds actions to notifications
            if success {
                let snackAction = UNNotificationAction(identifier: "snack", title: "Add snack", options: .foreground)
                let breakfastAction = UNNotificationAction(identifier: "breakfast", title: "Add breakfast", options: .foreground)
                let lunchAction = UNNotificationAction(identifier: "lunch", title: "Add lunch", options: .foreground)
                let dinnerAction = UNNotificationAction(identifier: "dinner", title: "Add dinner", options: .foreground)
                let mealEntryCategory = UNNotificationCategory(identifier: "MealEntry", actions: [snackAction, breakfastAction, lunchAction, dinnerAction], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([mealEntryCategory])
                NSLog("Successfully registered notification support")
            } else {
                NSLog("Error requesting authorization status for local notifications: \(String(describing: error?.localizedDescription))")
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func createNotification(hour: Int, minute: Int, id: Int, note: String) {
        let content = UNMutableNotificationContent()
        content.title = "Meal reminder"
        content.body = note
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "MealEntry" // Category id for notification actions
        
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = minute
        
        let notificationRequest = UNNotificationRequest(identifier: "\(id)", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true))
        
        center.add(notificationRequest) { (error) in
            if let error = error {
                NSLog("There was an error scheduling a notification: \(error)")
            }
        }
    }
    
    func alarmsNotSetup(alarms: [Alarm], completion: @escaping ([Alarm]?) -> ()) {
        
        var result = alarms
        center.getPendingNotificationRequests { (notifications) in
            for notification in notifications {
                for (index, alarm) in result.enumerated() {
                    if notification.identifier == String(alarm.id) {
                        result.remove(at: index)
                    }
                }
            }
            
            completion(result)
        }
    }
    
    func deleteNotification(with id: Int) {
        center.removePendingNotificationRequests(withIdentifiers: ["\(id)"])
    }
    
    func editNotification(with alarm: Alarm) {
        
        
    }
}
