//
//  MealTableViewCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 08.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class FoodTableViewCell<Resource>: UITableViewCell {
    
    // MARK: - Public properties
    
    var food: Resource? {
        didSet {
            setupViews()
        }
    }
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    let selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "checked")!.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = UIColor.lightGray
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Meal"
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    private let servingQtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 cups"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - User Actions
    
    @objc func selectRow(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        let tintColor = button.isSelected
            ? UIColor.green
            : UIColor.lightGray

        button.tintColor = tintColor
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(selectButton)
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(servingQtyLabel)
        
        mainStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
        
        selectButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // selectButton.addTarget(self, action: #selector(selectRow), for: .touchUpInside)
        
        if let recipe = food as? Recipe {
            nameLabel.text = recipe.name
            
            guard let serving = recipe.servings else { return }
            if serving > 1 {
                servingQtyLabel.text = "\(serving) servings"
            } else {
                servingQtyLabel.text = "\(serving) serving"
            }
            
        } else if let ingredient = food as? Ingredient {
            nameLabel.text = ingredient.name
            servingQtyLabel.text = nil
        }
        
    }

}
