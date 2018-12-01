//
//  MealTableViewCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 08.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol FoodTableViewCellDelegate: class {
    func selectFood(from cell: UITableViewCell)
}

class FoodTableViewCell<Resource>: UITableViewCell {
    
    // MARK: - Public properties
    
    var food: Resource? {
        didSet {
            setupViews()
        }
    }
    weak var delegate: FoodTableViewCellDelegate?
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    let selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(named: "checked")!.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = UIColor.lightGray
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Appearance.appFont(with: 17)
        label.sizeToFit()
        return label
    }()
    
    private let servingQtyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Appearance.appFont(with: 14)
        label.sizeToFit()
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
        delegate?.selectFood(from: self)
    }
    
    func updateLayouts() {
        selectButton.isSelected = !selectButton.isSelected
        
        selectButton.tintColor = selectButton.isSelected
            ? UIColor.green
            : UIColor.lightGray
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
        selectButton.addTarget(self, action: #selector(selectRow), for: .touchUpInside)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        if let recipe = food as? Recipe {
            nameLabel.text = recipe.name
            
            if recipe.servings > 1 {
                servingQtyLabel.text = "\(recipe.servings) servings"
            } else {
                servingQtyLabel.text = "\(recipe.servings) serving"
            }
            
        } else if let ingredient = food as? Ingredient {
            nameLabel.text = ingredient.name
            servingQtyLabel.text = nil
        }
        
    }
    
}
