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
        label.font = Appearance.appFont(with: 16)
        label.text = "Meal name"
        label.textColor = .white
        
        return label
    }()
    
    let servingsLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 14)
        label.text = "Servings: 2"
        label.textColor = .white
        
        return label
    }()
    
    let mealTimeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 14)
        label.textColor = .white
        label.text = "Dinner"
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 16)
        label.text = "Date 11/11/2011"
        label.textColor = .white
        
        return label
    }()
    
    let experienceLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 14)
        label.text = "Experience"
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupViews()
        
        setGradientBackground(colorOne: UIColor.sunOrange.cgColor, colorTwo: UIColor.sunRed.cgColor, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(mealNameLabel)
        addSubview(dateLabel)
        addSubview(experienceLabel)
        addSubview(servingsLabel)
        addSubview(mealTimeLabel)
        
        mealNameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0))

        dateLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12))
        
        servingsLabel.anchor(top: mealNameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 0))
        
        mealTimeLabel.anchor(top: dateLabel.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 12))
        
        experienceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        experienceLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
