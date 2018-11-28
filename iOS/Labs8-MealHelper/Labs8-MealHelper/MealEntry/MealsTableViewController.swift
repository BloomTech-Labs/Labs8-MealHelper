//
//  MealsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

class MealsTableViewController: FoodsTableViewController<Recipe, FoodTableViewCell<Recipe>> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foods = FoodClient.shared.recipes
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foods = FoodClient.shared.recipes
        //        FoodClient.shared.fetchRecipes(for: User()) { (response) in
        //            DispatchQueue.main.async {
        //                switch response {
        //                case .success(let recipes):
        //                    self.foods = recipes
        //                case .error(let error):
        //                    // Handle error in UI
        //                    break
        //                }
        //            }
        //        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! FoodTableViewCell<Recipe>
        
        guard let recipe = foods?[indexPath.row] else { return cell }
        cell.food = recipe
        cell.delegate = self
        
        return cell
    }
    
    override func actionWhenNoItemsSelected() {
        let ingredientsVC = IngredientsTableViewController(navTitle: "Ingredients")
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    override func actionWhenItemsSelected() {
        let mealSetupVC = MealSetupTableViewController()
        mealSetupVC.recipes = getSelectedFoods()
        navigationController?.pushViewController(mealSetupVC, animated: true)
    }
    
}
