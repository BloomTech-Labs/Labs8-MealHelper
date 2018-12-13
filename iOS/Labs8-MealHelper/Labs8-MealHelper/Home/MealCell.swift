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
   
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    let mealTimeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .white
        
        return iv
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        return view
    }()
    
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 18)
        label.text = "Meal name"
        label.textColor = .white
        
        return label
    }()
    
    let servingsLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 12)
        label.text = "Servings: 2"
        label.textColor = UIColor.init(white: 0.8, alpha: 1)
        
        return label
    }()
    
    lazy var experienceImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .correctGreen
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMealExperience)))
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupViews()
    }
    
    @objc private func handleMealExperience() {
        let newValue = meal?.experience == "0" ? "1" : "0"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(blurEffect)
        addSubview(mealTimeImageView)
        addSubview(seperatorLine)
        addSubview(experienceImageView)
        addSubview(mealNameLabel)
        addSubview(servingsLabel)
        
        blurEffect.fillSuperview()
        
        mealTimeImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        mealTimeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        seperatorLine.anchor(top: topAnchor, leading: mealTimeImageView.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 12, bottom: 10, right: 0), size: CGSize(width: 0.5, height: 0))
        
        experienceImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: CGSize(width: 30, height: 30))
        experienceImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mealNameLabel.anchor(top: topAnchor, leading: seperatorLine.trailingAnchor, bottom: nil, trailing: experienceImageView.leadingAnchor, padding: .init(top: 8, left: 12, bottom: 0, right: 8))
        
        servingsLabel.anchor(top: mealNameLabel.bottomAnchor, leading: seperatorLine.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 4, left: 12, bottom: 0, right: 0))
    }
}
