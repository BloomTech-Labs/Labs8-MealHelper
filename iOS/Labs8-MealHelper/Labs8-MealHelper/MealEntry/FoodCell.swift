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
    
    var sidePadding: CGFloat = 12
    var defaultBackgroundColor: UIColor = .morningSkyBlue
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .correctGreen : defaultBackgroundColor
        }
    }
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 15)
        label.text = "Meal name"
        label.numberOfLines = 2
        return label
    }()
    
    let servingLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = Appearance.appFont(with: 14)
        
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
        backgroundColor = defaultBackgroundColor
        layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        mainStackView.addArrangedSubview(mealNameLabel)
        addSubview(mainStackView)
        
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: sidePadding, bottom: 8, right: sidePadding))
        
        if let recipe = food as? Recipe {
            mainStackView.addArrangedSubview(servingLabel)
            
            mealNameLabel.text = recipe.name
            
            let servings = recipe.servings
            servingLabel.text = servings > 1 ? "\(servings) servings" : "\(servings) serving"
            
        } else if let ingredient = food as? Ingredient {
            mealNameLabel.text = ingredient.name
        
        }
        
    }
    
}

