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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let recipe = self.foods?[indexPath.row] else { return nil }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (save, indexPath) in
            let editRecipeVC = EditRecipeViewController()
            editRecipeVC.ingredients = recipe.ingredients
            editRecipeVC.recipeName = recipe.name
            self.navigationController?.pushViewController(editRecipeVC, animated: true)
        }
        edit.backgroundColor = .green
        
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { (remove, indexPath) in
            let foodClient = FoodClient.shared
            
            if let id = recipe.identifier {
                
                foodClient.deleteRecipe(withId: String(id), completion: { (response) in
                    switch response {
                    case .success(let response):
                        if response == 1 {
                            guard let index = self.foods?.index(of: recipe) else { return }
                            self.foods?.remove(at: index)
                            self.tableView.reloadData()
                    }
                    
                    case .error(let error):
                        print(error)
                        //Handle error
                    }
                })
                    
            }
        }
        
        return [remove, edit]
    }
    
    override func actionWhenNoItemsSelected() {
        let ingredientsVC = SearchIngredientsTableViewController(navTitle: "Ingredients")
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    override func actionWhenItemsSelected() {
        let foods = getSelectedFoods()
        let date = Utils().dateString(for: Date())
        var temp = 0.0 // TODO: Change
        
        let weatherDispatchGroup = DispatchGroup()
        
        weatherDispatchGroup.enter()
        WeatherAPIClient().fetchWeather(for: 8038) { (weatherForecast) in
            
            temp = weatherForecast?.main.temp ?? 0
            weatherDispatchGroup.leave()
        }
        
        weatherDispatchGroup.notify(queue: .main) {
            let foodDispatchGroup = DispatchGroup()
            
            for food in foods {
                foodDispatchGroup.enter()
                let name = food.name ?? ""
                
                FoodClient.shared.postMeal(name: name, mealTime: name, date: date, temp: temp) { (response) in
                    foodDispatchGroup.leave()
                }
            }
            
            foodDispatchGroup.notify(queue: .main) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
}
