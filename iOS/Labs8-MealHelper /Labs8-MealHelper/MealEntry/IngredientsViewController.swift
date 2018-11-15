//
//  IngredientsViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class IngredientDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    
    
    // MARK: - Private properties
    
    private let ingredientSummaryView = FoodSummaryView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(ingredientSummaryView)
        
        ingredientSummaryView.anchor(top: view.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, size: CGSize(width: 0.0, height: 100.0))
        
    }

}
