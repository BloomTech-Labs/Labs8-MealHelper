//
//  IngredientDetailViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

class IngredientDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    
    
    // MARK: - Private properties
    
    private let ingredientSummaryView = FoodSummaryView()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private properties
    
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(ingredientSummaryView)
        
        containerView.centerInSuperview(size: CGSize(width: view.bounds.width * 0.9, height: view.bounds.height * 0.8))
        ingredientSummaryView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        ingredientSummaryView.backgroundColor = UIColor.lightGray
    }
    
}
