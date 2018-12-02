//
//  NutrientsView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 30/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NutrientsView: UIView {
    
    let kcalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "18.4"
        label.textColor = .mountainDark
        label.font = Appearance.appFont(with: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    let carbsValueLabel: UILabel = {
        let label = UILabel()
        label.text = "12.1"
        label.textColor = .mountainDark
        label.font = Appearance.appFont(with: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    let fatValueLabel: UILabel = {
        let label = UILabel()
        label.text = "7.2"
        label.textColor = .mountainDark
        label.font = Appearance.appFont(with: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    let proteinValueLabel: UILabel = {
        let label = UILabel()
        label.text = "17.9"
        label.textColor = .mountainDark
        label.font = Appearance.appFont(with: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "kcal"
        label.textColor = .lightGray
        label.font = Appearance.appFont(with: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    let carbsLabel: UILabel = {
        let label = UILabel()
        label.text = "carbs"
        label.textColor = .lightGray
        label.font = Appearance.appFont(with: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    let fatLabel: UILabel = {
        let label = UILabel()
        label.text = "fat"
        label.textColor = .lightGray
        label.font = Appearance.appFont(with: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    let proteinLabel: UILabel = {
        let label = UILabel()
        label.text = "protein"
        label.textColor = .lightGray
        label.font = Appearance.appFont(with: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        
        let valueStackView = UIStackView(arrangedSubviews: [kcalValueLabel, carbsValueLabel, fatValueLabel, proteinValueLabel])
        valueStackView.axis = .horizontal
        valueStackView.distribution = .fillEqually
        valueStackView.spacing = 12
        
        addSubview(valueStackView)
        valueStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 40))
        
        let typeStackView = UIStackView(arrangedSubviews: [kcalLabel, carbsLabel, fatLabel, proteinLabel])
        typeStackView.axis = .horizontal
        typeStackView.distribution = .fillEqually
        typeStackView.spacing = 12
        
        addSubview(typeStackView)
        typeStackView.anchor(top: valueStackView.bottomAnchor, leading: valueStackView.leadingAnchor, bottom: nil, trailing: valueStackView.trailingAnchor, padding: UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
