//
//  InterfaceController.swift
//  Labs8-MealHelperWatch Extension
//
//  Created by De MicheliStefano on 14.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class InterfaceController: WKInterfaceController {

    var recipes: [Recipe]?
    var mealTime: String?
    let watchClient = WatchClient()
    @IBOutlet weak var mealTableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        registerUserNotificationSettings()
        scheduleLocalNotification()
        watchClient.fetchRecipes(for: 17) { (recipes, error) in
            if let error = error {
                NSLog("Error fetching recipes: \(error)")
            }
            
            if let recipes = recipes {
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.setupTable()
                }
            }
        }
    }

    func setupTable() {
        guard let recipes = recipes else { return }
        let recipesCount = recipes.count
        
        mealTableView.setNumberOfRows(recipesCount, withRowType: "RecipeRow")
        for index in 1...recipesCount {
            if let controller = mealTableView.rowController(at: index-1) as? RecipeRowController {
                let recipeName = recipes[index-1].name
                controller.recipeNameLabel.setText(recipeName)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Post selected meal
    }
    
}

extension InterfaceController {
    
    func registerUserNotificationSettings() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let snackAction = UNNotificationAction(identifier: "snack", title: "Snack", options: .foreground)
                let breakfastAction = UNNotificationAction(identifier: "breakfast", title: "Breakfast", options: .foreground)
                let lunchAction = UNNotificationAction(identifier: "lunch", title: "Lunch", options: .foreground)
                let dinnerAction = UNNotificationAction(identifier: "dinner", title: "Dinner", options: .foreground)
                let mealEntryCategory = UNNotificationCategory(identifier: "MealEntry", actions: [snackAction, breakfastAction, lunchAction, dinnerAction], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([mealEntryCategory])
                UNUserNotificationCenter.current().delegate = self
                NSLog("Successfully registered notification support")
            } else {
                NSLog("Error registering notification: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func scheduleLocalNotification() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                
                
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "Pawsome"
                
                var date = DateComponents()
                date.minute = 34
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                
                
                let notificationRequest = UNNotificationRequest(identifier: "Pawsome", content: notificationContent, trigger: notificationTrigger)
                
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        print("⌚️⌚️⌚️ERROR:\(error.localizedDescription)")
                    } else {
                        print("⌚️⌚️⌚️Local notification was scheduled")
                    }
                }
            } else {
                print("⌚️⌚️⌚️Notification alerts are disabled")
            }
        }
    }
}

// Notification Center Delegate
extension InterfaceController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Get userId
        // Fetch the user's saved recipes
        // Populate tableview with meals
        watchClient.fetchRecipes(for: 2) { (recipes, error) in
            if let error = error {
                NSLog("Error fetching recipes: \(error)")
            }
            
            if let recipes = recipes {
                self.recipes = recipes
            }
        }
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Check what meal time the user chose
        
        completionHandler()
    }
    
}
