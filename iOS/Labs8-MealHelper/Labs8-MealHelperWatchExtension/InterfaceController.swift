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
    let mealTimes = [("snack", "Add snack"), ("breakfast", "Add breakfast"), ("lunch", "Add lunch"), ("dinner", "Add dinner")] // (id, name)
    let watchClient = WatchClient()
    @IBOutlet weak var recipesTableView: WKInterfaceTable!
    @IBOutlet weak var mealTimeTableView: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        UNUserNotificationCenter.current().delegate = self
        watchClient.fetchRecipes(for: 17) { (recipes, error) in
            if let error = error {
                NSLog("Error fetching recipes: \(error)")
            }
            
            if let recipes = recipes {
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.setupRecipeTable()
                }
            }
        }
    }

    func setupRecipeTable() {
        guard let recipes = recipes else { return }
        let recipesCount = recipes.count
        
        recipesTableView.setNumberOfRows(recipesCount, withRowType: "RecipeRow")
        for index in 1...recipesCount {
            if let controller = recipesTableView.rowController(at: index-1) as? RecipeRowController {
                let recipeName = recipes[index-1].name
                controller.recipeNameLabel.setText(recipeName)
            }
        }
    }
    
    func setupMealTimeTable() {
        let mealTimesCount = mealTimes.count
        
        mealTimeTableView.setNumberOfRows(mealTimesCount, withRowType: "MealTimeRow")
        for index in 1...mealTimesCount {
            if let controller = mealTimeTableView.rowController(at: index-1) as? MealTimeRowController {
                let mealTimeName = mealTimes[index-1].1
                controller.mealTimeLabel.setText(mealTimeName)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Post selected meal
    }
    
}

extension InterfaceController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Called when user performs an action on notification
        // Check what meal time the user chose
        switch response.actionIdentifier {
        case "snack":
            print("snack")
        case "breakfast":
            print("breakfast")
        case "lunch":
            print("lunch")
        case "dinner":
            print("dinner")
        default:
            break
        }
        // provide completionhandler with a block to be executed
        completionHandler()
    }
    
}
