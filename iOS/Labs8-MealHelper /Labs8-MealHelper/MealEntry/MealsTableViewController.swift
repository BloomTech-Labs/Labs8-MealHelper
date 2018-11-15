//
//  MealsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

class MealsTableViewController: FoodsTableViewController {
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! MealTableViewCell
        
        guard let recipe = foods[indexPath.row] as? String else { return cell }
        cell.recipe = recipe
        
        return cell
    }
    
    override func noItemsSelectedAction() {
        let ingredientsVC = IngredientsTableViewController(navTitle: "Ingredients", cell: MealTableViewCell.self, foods: ["Chicken tandori", "Pork BBQ", "French Fries"])
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    override func itemsSelectedAction() {
        let mealSetupVC = MealSetupTableViewController()
        navigationController?.pushViewController(mealSetupVC, animated: true)
    }
    
}
