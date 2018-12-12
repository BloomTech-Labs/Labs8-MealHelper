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
    var defaultBackgroundColor: UIColor = .clear
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .lightPurple : defaultBackgroundColor
        }
    }
    
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frost.layer.cornerRadius = 8
        frost.layer.masksToBounds = true
        
        return frost
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(with: 15)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let servingLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.font = Appearance.appFont(with: 14)
        
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
        addSubview(blurEffect)
        mainStackView.addArrangedSubview(mealNameLabel)
        addSubview(mainStackView)
        
        blurEffect.fillSuperview()
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

