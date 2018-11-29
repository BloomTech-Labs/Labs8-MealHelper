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
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if let error = error { NSLog("Error requesting authorization status for local notifications: \(error)") }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func scheuleDailyReminderNotification()
    {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Remember to add a memory for today!"
        content.sound = UNNotificationSound.default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 20 //Not sure how to set it to 8PM?
        
        let notificationRequest = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false))
        
        let center = UNUserNotificationCenter.current()
        center.add(notificationRequest) { (error) in
            if let error = error
            {
                NSLog("There was an error scheduling a notification: \(error)")
            }
        }
    }
    
    
}
