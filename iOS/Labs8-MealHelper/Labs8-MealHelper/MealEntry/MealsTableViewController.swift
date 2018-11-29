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
    
    lazy var cancelBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissMealView))
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foods = FoodClient.shared.recipes
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBarButton
        
        //foods = FoodClient.shared.recipes
        FoodClient.shared.fetchRecipes { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let recipes):
                    self.foods = recipes
                case .error(let error):
                    print(error)
                    // Handle error in UI
                    break
                }
            }
        }
    }
    
    @objc private func dismissMealView() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! FoodTableViewCell<Recipe>
        
        guard let recipe = foods?[indexPath.row] else { return cell }
        cell.food = recipe
        cell.delegate = self
        
        return cell
    }
    
    override func actionWhenNoItemsSelected() {
        let ingredientsVC = SearchIngredientsTableViewController(navTitle: "Ingredients")
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    override func actionWhenItemsSelected() {
        let foods = getSelectedFoods()
        // TODO: save selected meals
        FoodClient.shared.postMeal(name: "test", mealTime: "Lunch", experience: "happy", date: "11/16/2018", temp: 123.0) { (response) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
