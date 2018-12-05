//
//  FoodCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 03.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class FoodCell<T>: UICollectionViewCell {
    
    var food: T? {
        didSet {
            setupViews()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .green : .white
        }
    }
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        //label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 15)
        label.text = "Meal name"
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 12)
        label.text = "Date 11/11/2011"
        
        return label
    }()
    
    let experienceLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 14)
        label.text = "Experience"
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(mealNameLabel)
//        addSubview(dateLabel)
//        addSubview(experienceLabel)
        
        mealNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mealNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        mealNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
//        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
//        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        experienceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        experienceLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        if let recipe = food as? Recipe {
            mealNameLabel.text = recipe.name
            
        } else if let ingredient = food as? Ingredient {
            mealNameLabel.text = ingredient.name
        }
        
    }
    
    func toggleSelected() {
        backgroundColor = isSelected ? .green : .white
    }
    
}

