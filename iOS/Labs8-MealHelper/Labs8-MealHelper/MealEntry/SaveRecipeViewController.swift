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
            
        }
    }
    
    // MARK: - Private properties

    private let recipeSettingsVC: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
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
        tv.view.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let ingredientTableVC: IngredientTableViewController = {
        let tv = IngredientTableViewController()
        tv.view.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    // MARK: - User actions
    
    @objc private func save() {
        // Save recipe
    }
    
    // MARK: - Configuration
    
    private func setupViews() {

        recipeSettingsVC.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        ingredientTableVC.tableView.anchor(top: recipeSettingsVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
}

