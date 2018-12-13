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
    var recipe: Recipe?
    
    var recipeName: String?
    var serving: Int = 1
    var mealTime = "Snack"

    // MARK: - Private properties

    private let sidePadding: CGFloat = 20.0
    
    private lazy var recipeSettingsVC: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        vc.view.layer.cornerRadius = 12
        vc.quantityPickerFieldValues = ["Breakfast", "Lunch", "Dinner", "Snack"]
        vc.quantityPickerFieldDefaultValue = String(serving)
        vc.typePickerFieldValues = (1...20).map { String($0) }
        vc.typePickerFieldDefaultValue = mealTime
        vc.editableTitle = true
        vc.setupViews()
        return vc
    }()
    
    private let ingredientTableVC: IngredientTableViewController = {
        let tv = IngredientTableViewController()
        tv.tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tv.tableView.layer.cornerRadius = 12
        return tv
    }()
    
    private lazy var saveBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mountain"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return frost
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mountainDark
        title = "Save Recipe"
        
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
        
        // Save recipe with all its ingredients, incl. nutrient values
        
        guard let recipeName = recipeName else {
            NSLog("No recipe name provided")
            showAlert(with: "Please provide a recipe name.")
            return
        }
        
        saveRecipe(with: recipeName, calories: getTotalCalories(), servings: serving) { recipe in
            
            guard let recipe = recipe else { return }

            self.ingredients?.forEach { ingredient in
                // Save nutrients of ingredient
                
                self.saveIngredient(with: ingredient.name, ndbno: ingredient.nbdId, recipeId: recipe.identifier, completion: { savedIngredient in
                    
                    guard let nutrients = ingredient.nutrients else {
                        NSLog("Ingredient has no nutrients and/or identifier")
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    nutrients.forEach { nutrient in
                        
                        dispatchGroup.enter()
                        self.saveNutrient(with: nutrient, recipeId: recipe.identifier, completion: { (_) in
                            dispatchGroup.leave()
                        })
                    }
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        print("Saved recipe succeeded")
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    
                })
                
            }
            
        }
    }
    
    @objc private func handleKeyboard(notification: NSNotification) {
        
    }
    
    @objc private func handleMealSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo, let pickedMealTime = userInfo["type"] as? String {
            self.mealTime = pickedMealTime
        }
        
        if let userInfo = notification.userInfo, let pickedServingString = userInfo["quantity"] as? String, let pickedServingInt = Int(pickedServingString) {
            self.serving = pickedServingInt
        }
    }
    
    @objc private func handleRecipeNameSetting(notification: NSNotification) {
        if let userInfo = notification.userInfo, let recipeName = userInfo["textField"] as? String {
            self.recipeName = recipeName
        }
    }
    
    // MARK: - Persistence
    
    func saveRecipe(with name: String, calories: Int, servings: Int, completion: @escaping (Recipe?) -> ()) {
        FoodClient.shared.postRecipe(name: name, calories: calories, servings: servings) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let recipes):
                        if let newRecipe = recipes.last {
                            print("Sucessfully saved recipes")
                            completion(newRecipe)
                            return
                        }
                        
                        NSLog("Response did not contain any recipes")
                        completion(nil)
                case .error(let error):
                        NSLog("Error saving recipe: \(error)")
                        self.showAlert(with: "Could not save recipe. Please try again.")
                        completion(nil)
                }
            }
            
        }
    }
    
    func saveIngredient(with name: String, ndbno: Int?, recipeId: Int, completion: @escaping (Ingredient?) -> ()) {
        FoodClient.shared.postIngredient(name: name, ndbno: ndbno, recipeId: recipeId, completion: { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    if let newIngred = ingredients.last {
                        completion(newIngred)
                        return
                    } else {
                        NSLog("Response did not contain ingredients")
                        completion(nil)
                    }
                case .error(let error):
                    NSLog("Error saving ingredients: \(error)")
                    completion(nil)
                }
            }
        })
    }
    
    func saveNutrient(with nutrient: Nutrient, recipeId: Int, completion: @escaping (Error?) -> ()) {
        FoodClient.shared.postNutrient(nutrient, recipeId: recipeId, completion: { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success( _):
                    completion(nil)
                case .error(let error):
                    NSLog("Nutrient could not be saved: \(error)")
                    completion(error)
                }
            }
        })
    }
    
    // MARK: - Private methods
    
    private func getTotalCalories() -> Int {
        guard let ingredients = ingredients else { return 0 }
        
        var calories = 0
        
        for ingredient in ingredients {
            guard let nutrients = ingredient.nutrients else { continue }
            for nutrient in nutrients {
                if nutrient.nutrientId == 208 { // id for energy/kcal
                    calories += Int(nutrient.value) ?? 0
                }
            }
        }
        
        return calories
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(blurEffect)
        blurEffect.fillSuperview()

        add(recipeSettingsVC)
        recipeSettingsVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 130))
        recipeSettingsVC.inputStackView.removeArrangedSubview(recipeSettingsVC.typeInputField)
        
        add(ingredientTableVC)
        ingredientTableVC.tableView.anchor(top: recipeSettingsVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 40, right: sidePadding))
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleMealSetting), name: .MHFoodSummaryPickerDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecipeNameSetting), name: .MHFoodSummaryTextFieldDidChange, object: nil)
    }
    
}

class EditRecipeViewController: SaveRecipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Recipe"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let ingredients = ingredients else { return }
        
        ingredients.forEach { ingredient in
            if let index = ingredients.index(of: ingredient), let updatedIngredient = addNutrients(to: ingredient) {
                self.ingredients?.remove(at: index)
                self.ingredients?.insert(updatedIngredient, at: index)
            }
        }
    }
    
    override func saveRecipe(with name: String, calories: Int, servings: Int, completion: @escaping (Recipe?) -> ()) {
        FoodClient.shared.postRecipe(name: name, calories: calories, servings: servings) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success( _):
                    print("saved recipe successfully")
                    self.navigationController?.popViewController(animated: true)
                case .error(let error):
                    NSLog("Error saving recipe: \(error)")
                    self.showAlert(with: "Could not save recipe. Please try again.")
                    break
                }
            }
        }
    }
    
    func addNutrients(to ingredient: Ingredient) -> Ingredient? {
        var updatedIngredient = ingredient
        
        guard let recipeId = ingredient.recipeId else { return nil }
        
        FoodClient.shared.fetchNutrients(withRecipeId: recipeId) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let nutrients):
                    updatedIngredient.nutrients = nutrients
                case .error(let error):
                    print(error)
                    // Handle error in UI
                    break
                }
            }
        }
        
        return updatedIngredient
    }
}
