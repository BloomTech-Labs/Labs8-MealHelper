//
//  RecipeCollectionViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 03.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class RecipeCollectionViewController: FoodsCollectionViewController<Recipe> {

    lazy var cancelBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        navigationItem.leftBarButtonItem = cancelBarButton
        
        FoodClient.shared.fetchRecipes { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let recipes):
                    self.foods = recipes
                    self.collectionView.reloadData()
                case .error:
                    self.showAlert(with: "We couldn't get your recipes, please check your internet connection and try again.")
                    return
                }
            }
        }
    }

    override func didSelectItems() {
        let foods = getSelectedFoods()
        let date = Utils().dateString(for: Date())
        var temp = 0.0 // TODO: Change
        
        let weatherDispatchGroup = DispatchGroup()
        
        weatherDispatchGroup.enter()
        WeatherAPIClient().fetchWeather(for: 8038) { (weatherForecast) in // TODO: Change
            
            temp = weatherForecast?.main.temp ?? 0
            weatherDispatchGroup.leave()
        }
        
        weatherDispatchGroup.notify(queue: .main) {
            let foodDispatchGroup = DispatchGroup()
            
            for food in foods {
                foodDispatchGroup.enter()
                let name = food.name
                
                FoodClient.shared.postMeal(name: name, mealTime: name, date: date, temp: temp) { (response) in
                    foodDispatchGroup.leave()
                }
            }
            
            foodDispatchGroup.notify(queue: .main) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didNotSelectItems() {
        //let ingredientsVC = SearchIngredientsTableViewController(navTitle: "Ingredients")
        let layout = UICollectionViewFlowLayout()
        let searchIngredientVC = SearchIngredientCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(searchIngredientVC, animated: true)
    }
    
}
