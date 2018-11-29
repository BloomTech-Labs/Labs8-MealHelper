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

    private let recipeSettingsVC: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.backgroundColor = UIColor.lightGray
        vc.rightPickerFieldValues = (1...20).map { String($0) }
        vc.rightPickerFieldDefaultValue = "1"
        vc.leftPickerFieldValues = ["Breakfast", "Lunch", "Dinner", "Snack"]
        vc.leftPickerFieldDefaultValue = "Snack"
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
        title = "Recipe"
        
        add(recipeSettingsVC)
        add(ingredientTableVC)
        
        setupViews()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
    }
    
    // MARK: - User actions
    
    @objc private func save() {
        // Save recipe
    }
    
    
    @objc private func handleKeyboard(notification: NSNotification) {
        
    }
    
    // MARK: - Configuration
    
    private func setupViews() {

        recipeSettingsVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        ingredientTableVC.tableView.anchor(top: recipeSettingsVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

