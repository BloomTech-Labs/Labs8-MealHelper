//
//  SaveMealViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 12.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SaveMealViewController: UIViewController {
    
    // MARK: - Public properties
    
    var recipes: [Recipe]? {
        didSet {
            updateViews()
        }
    }
    
    var serving: Int = 1
    var mealTime = "Snack"
    
    // MARK: - Private properties
    
    private var ingredients: [Ingredient] = [Ingredient]() {
        didSet {
            ingredientTableVC.ingredients = ingredients
        }
    }
    
    private let sidePadding: CGFloat = 20.0
    
    private lazy var mealSettingsVC: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        vc.view.layer.cornerRadius = 12
        vc.quantityPickerFieldValues = ["Breakfast", "Lunch", "Dinner", "Snack"]
        vc.quantityPickerFieldDefaultValue = String(serving)
        vc.typePickerFieldValues = (1...20).map { String($0) }
        vc.typePickerFieldDefaultValue = mealTime
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
        title = "Save Meal"
        
        setupViews()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        setupRecipeSettingsNotifications()
    }
    
    // MARK: - User actions
    
    @objc private func save() {
        saveMeals()
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
    
    // MARK: - Persistence
    
    private func saveMeals() {
        guard let recipes = recipes else { return }
        
        let date = Utils().dateString(for: Date())
        let zipCode = UserDefaults().loggedInZipCode()!
        var temp: Double?
        var humidity: Double?
        var pressure: Double?
        
        let weatherDispatchGroup = DispatchGroup()
        
        weatherDispatchGroup.enter()
        WeatherAPIClient().fetchWeather(for: zipCode) { (weatherForecast) in // TODO: Change
            
            temp = weatherForecast?.main.temp
            humidity = weatherForecast?.main.humidity
            pressure = weatherForecast?.main.pressure
            weatherDispatchGroup.leave()
        }
        
        weatherDispatchGroup.notify(queue: .main) {
            let foodDispatchGroup = DispatchGroup()
            
            for recipe in recipes {
                foodDispatchGroup.enter()
                
                FoodClient.shared.postMeal(name: recipe.name, mealTime: self.mealTime, date: date, experience: "1", temp: temp, pressure: pressure, humidity: humidity, recipeId: recipe.identifier, servings: self.serving) { (response) in
                    foodDispatchGroup.leave()
                }
            }
            
            foodDispatchGroup.notify(queue: .main) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func fetchIngredients() {
        guard let recipes = recipes else { return }
        var fetchedIngredients = [Ingredient]()
        let dispatchGroup = DispatchGroup()
        
        for recipe in recipes {
            dispatchGroup.enter()
            FoodClient.shared.fetchIngredients(withRecipeId: recipe.identifier) { (response) in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let ingredients):
                        fetchedIngredients.append(contentsOf: ingredients)
                    case.error(let error):
                        NSLog("Could not fetch recipe's ingredients: \(error)")
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.ingredients.append(contentsOf: fetchedIngredients)
        }
    }
    
    // MARK: - Private methods
    
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        add(mealSettingsVC)
        mealSettingsVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 130))
        
        add(ingredientTableVC)
        ingredientTableVC.tableView.anchor(top: mealSettingsVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 40, right: sidePadding))
        
        navigationItem.setRightBarButton(saveBarButton, animated: true)
    }
    
    private func updateViews() {
        guard let recipes = recipes else { return }
        
        if recipes.count > 1 {
            mealSettingsVC.titleName = "Multiple Recipes"
        } else {
            mealSettingsVC.titleName = recipes.first?.name
        }
        
        fetchIngredients()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupRecipeSettingsNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMealSetting), name: .MHFoodSummaryPickerDidChange, object: nil)
    }
    
}
