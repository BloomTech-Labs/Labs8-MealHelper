//
//  MealCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
    
    var meal: Meal? {
        didSet {
            setupViews()
        }
    }
   
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 14)
        label.text = "Meal name"
        
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
        backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(mealNameLabel)
        addSubview(dateLabel)
        addSubview(experienceLabel)
        
        mealNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mealNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        experienceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        experienceLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
