//
//  FoodLabelView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 04.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class FoodLabelView: UIView {
    
    var foodLabels = ["Gluten-free", "No sugar", "High-fiber", "Low Fats", "High Protein", "Low-Sodium"]

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFoodLabels() {
        var previous: UILabel?
        let labelHeight: CGFloat = 30.0
        let padding: CGFloat = 8.0
        var accumulatedWidth: CGFloat = 0.0
        var accumulatedHeight: CGFloat = 0.0
        
        for (index, label) in foodLabels.enumerated() {
            let isSelected = index % 2 == 0 ? true: false // TODO: Add logic
            let foodLabel = createFoodLabel(with: label, isSelected: isSelected)
            self.addSubview(foodLabel)
            
            foodLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
            foodLabel.widthAnchor.constraint(equalToConstant: foodLabel.intrinsicContentSize.width + 20.0).isActive = true
            accumulatedWidth += foodLabel.intrinsicContentSize.width + 20.0
            
            if let previous = previous {
                if accumulatedWidth > self.bounds.width {
                    foodLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: padding).isActive = true
                    accumulatedWidth = 0.0
                    accumulatedHeight += labelHeight + padding
                } else {
                    foodLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: accumulatedHeight).isActive = true
                    foodLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: padding).isActive = true
                }
            }
            
            previous = foodLabel
        }
        
        self.heightAnchor.constraint(equalToConstant: accumulatedHeight + labelHeight + padding).isActive = true
        
        superview?.layoutIfNeeded()
    }
    
    private func createFoodLabel(with title: String, isSelected: Bool) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textAlignment = .center
        label.font = Appearance.appFont(with: 12)
        label.layer.cornerRadius = 30 / 2
        label.layer.masksToBounds = true
        label.backgroundColor = isSelected ? .mountainBlue : UIColor.lightGray
        return label
    }

}
