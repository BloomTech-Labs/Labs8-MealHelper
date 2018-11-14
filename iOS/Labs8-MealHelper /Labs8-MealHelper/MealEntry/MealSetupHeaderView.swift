//
//  MealSetupHeaderView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealSetupHeaderView: UIView {
    
    // MARK: - Public properties
    
    var nutrients = [("216 cal", "Calories"), ("30 g", "Carbs"), ("7 g", "Fat"), ("8 g", "Protein")]
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        
        self.addSubview(mainStackView)
        
        for nutrient in nutrients {
            let label = createLabel(with: nutrient.0, subtitle: nutrient.1)
            mainStackView.addArrangedSubview(label)
        }
        
        mainStackView.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor)
        
    }
    
    private func createLabel(with text: String, subtitle: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "\(text)\n\(subtitle)"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }
    
}
