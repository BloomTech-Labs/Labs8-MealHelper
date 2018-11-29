//
//  SaveRecipeViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 28.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SaveRecipeViewController: UIViewController {
    
    // MARK: - Public properties
    
    var ingredients: [Ingredient]? {
        didSet {
            ingredientTableVC.ingredients = ingredients
        }
    }
    
    var recipeName: String?
    var serving: Int = 1
    var mealTime = "Snack"
    
    // MARK: - Private properties

    private lazy var recipeSettingsVC: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.backgroundColor = UIColor.lightGray
        vc.quantityPickerFieldValues = ["Breakfast", "Lunch", "Dinner", "Snack"]
        vc.quantityPickerFieldDefaultValue = String(serving)
        vc.typePickerFieldValues = (1...20).map { String($0) }
        vc.typePickerFieldDefaultValue = mealTime
        vc.editableTitle = true
        vc.setupViews()
        return vc
    }()
    
    private let nutrientTableVC: NutrientDetailTableViewController = {
        let tv = NutrientDetailTableViewController()
        return tv
    }()
    
    private let ingredientTableVC: IngredientTableViewController = {
        let tv = IngredientTableViewController()
        return tv
    }()
    
    private lazy var saveBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mountainDark
        title = "Save Recipe"
        
        add(recipeSettingsVC)
        add(ingredientTableVC)
        
        setupViews()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        setupRecipeSettingsNotifications()
    }
    
    // MARK: - User actions
    
    @objc private func save() {
//        guard let ingredients = self.ingredients, let recipeName = recipeName else {
//            NSLog("No ingredients added to recipe")
//            return
//        }
        
        var ingredientIds = [Int]()
        
        ingredients?.forEach { ingredient in
            // Save nutrients of ingredient
            guard let nutrients = ingredient.nutrients else {
                NSLog("Ingredient has no nutrients")
                return
            }
            let dispatchGroup = DispatchGroup()
            
            var nutrientIds = [Int]()
            nutrients.forEach { nutrient in
                dispatchGroup.enter()
                FoodClient.shared.postNutrient(nutrient, completion: { (response) in
                    switch response {
                    case .success(let nutrientId):
                        nutrientIds.append(nutrientId)
                    case .error(let error):
                        print(error)
                        // Handle error in UI
                        break
                    }
                    
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                FoodClient.shared.postIngredient(ingredient, completion: { (response) in
                    switch response {
                    case .success(let ingredientId):
                        FoodClient.shared.putIngredient(withId: ingredientId, nutrientIds: nutrientIds, completion: { (response) in
                            switch response {
                            case .success(let nutrientId):
                                nutrientIds.append(nutrientId)
                            case .error(let error):
                                print(error)
                                // Handle error in UI
                                break
                            }
                        })
                        
                    case .error(let error):
                        print(error)
                        // Handle error in UI
                        break
                    }
                })
            })
            
        }
        
        // Save ingredient, incl. nutrient values
        
        saveRecipe(with: recipeName ?? "", calories: self.getTotalCalories(), servings: self.serving)
        
    }
    
    
    @objc private func handleKeyboard(notification: NSNotification) {
        
    }
    
    @objc private func handleMealTimeSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo, let pickedMealTime = userInfo["type"] as? String {
            self.mealTime = pickedMealTime
        }
    }
    
    @objc private func handleServingSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo, let pickedServingString = userInfo["quantity"] as? String, let pickedServingInt = Int(pickedServingString) {
            self.serving = pickedServingInt
        }
    }
    
    @objc private func handleRecipeNameSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo, let recipeName = userInfo["textField"] as? String {
            self.recipeName = recipeName
        }
    }
    
    // MARK: - Private methods
    
    func saveRecipe(with name: String, calories: Int, servings: Int) {
        FoodClient.shared.postRecipe(name: name, calories: calories, servings: servings) { (response) in
            switch response {
            case .success(let recipeId):
                print("saved recipe successfully for id: \(recipeId)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .error(let error):
                print(error)
                // Handle error in UI
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }// TODO: to be deleted
                break
            }
            
        }
        
    }
    
    private func getTotalCalories() -> Int {
        guard let ingredients = ingredients else { return 0 }
        
        var calories = 0
        
        for ingredient in ingredients {
            guard let nutrients = ingredient.nutrients else { continue }
            for nutrient in nutrients {
                if nutrient.identifier == "208" { // id for energy/kcal
                    calories += Int(nutrient.value) ?? 0
                }
            }
        }
        
        return calories
    }
    
    private func updateNutrients() {
        
    }
    
    // MARK: - Configuration
    
    private func setupViews() {

        recipeSettingsVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        ingredientTableVC.tableView.anchor(top: recipeSettingsVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        
        if let recipeName = recipeName {
            recipeSettingsVC.titleTextField.text = recipeName
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupRecipeSettingsNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMealTimeSetting), name: .MHFoodSummaryTypePickerDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleServingSetting), name: .MHFoodSummaryQuantityPickerDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecipeNameSetting), name: .MHFoodSummaryTextFieldDidChange, object: nil)
    }
    
}

class EditRecipeViewController: SaveRecipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Recipe"
    }
    
    override func saveRecipe(with name: String, calories: Int, servings: Int) {
        FoodClient.shared.postRecipe(name: name, calories: calories, servings: servings) { (response) in
            switch response {
            case .success(let recipeId):
                print("saved recipe successfully for id: \(recipeId)")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .error(let error):
                print(error)
                // Handle error in UI
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                } // TODO: to be deleted
                break
            }
        }
    }
    
}
