//
//  IngredientDetailViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

protocol SearchIngredientDetailDelegate: class {
    func updateIngredient(_ ingredient: Ingredient)
    func selectFood(at indexPath: IndexPath)
}

class SearchIngredientDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    var ingredient: Ingredient? {
        didSet {
            setupViews()
            nutrientTableView.nutrients = ingredient?.nutrients
        }
    }
    weak var delegate: SearchIngredientDetailDelegate?
    var delegateIndexPath: IndexPath? // TODO: add protocol
    var foodLabels = ["Gluten-free", "No sugar", "High-fiber", "Low Fat", "High Protein", "Low-Sodium"]
    
    // MARK: - Private properties
    
    private let ingredientSummaryView = FoodSummaryViewController()
    private let nutrientTableView = NutrientDetailTableViewController()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var foodLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to recipe", for: .normal)
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        button.backgroundColor = .mountainBlue
        button.tintColor = .white
        button.titleLabel?.font = Appearance.appFont(with: 17)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFoodLabels()
        setupNutrientTable()
        
        // Listen for user changing serving types or qty
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeServingType), name: .MHServingTypeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeServingQty), name: .MHServingQtyDidChange, object: nil)
    }
    
    // MARK: - User actions
    
    @objc private func addToBasket() {
        // Add to basket
        
        // When user taps on addToBasket then we tell the delegate VC to select and highlight the appropriate row
        dismiss(animated: true) {
            if let indexPath = self.delegateIndexPath, let ingredient = self.ingredient {
                self.delegate?.selectFood(at: indexPath)
                self.delegate?.updateIngredient(ingredient)
            }
        }
    }
    
    @objc private func didChangeServingType(note: Notification) {
        if let userInfo = note.userInfo, let servingType = userInfo["servingType"] as? FoodHelper.ServingTypes.RawValue, let nutrients = ingredient?.nutrients {
            let updatedNutrients = nutrients.map { (nutrient: Nutrient) -> Nutrient in
                var updatedNutrient = nutrient
                let convertedValue = FoodHelper().convertHundertGrams(nutrient.gm, to: servingType)
                updatedNutrient.value = String(format: "%.02f", convertedValue)
                updatedNutrient.unit = servingType
                return updatedNutrient
            }
            
            ingredient?.nutrients = updatedNutrients
        }
    }
    
    @objc private func didChangeServingQty(note: Notification) {
        if let userInfo = note.userInfo, let servingQty = userInfo["servingQty"] as? Double, let nutrients = ingredient?.nutrients {
            let updatedNutrients = nutrients.map { (nutrient: Nutrient) -> Nutrient in
                var updatedNutrient = nutrient
                let convertedValue = (Double(updatedNutrient.value) ?? 0) * servingQty
                updatedNutrient.value = String(format: "%.02f", convertedValue)
                return updatedNutrient
            }
            
            ingredient?.nutrients = updatedNutrients
        }
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(ingredientSummaryView.view)
        containerView.addSubview(foodLabelView)
        containerView.addSubview(nutrientTableView.tableView)
        containerView.addSubview(addButton)
        
        containerView.centerInSuperview(size: CGSize(width: view.bounds.width * 0.9, height: view.bounds.height * 0.8))
        ingredientSummaryView.view.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor)
        foodLabelView.anchor(top: ingredientSummaryView.view.bottomAnchor, leading: containerView.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: containerView.layoutMarginsGuide.trailingAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0))
        nutrientTableView.tableView.anchor(top: foodLabelView.bottomAnchor, leading: containerView.layoutMarginsGuide.leadingAnchor, bottom: addButton.topAnchor, trailing: containerView.layoutMarginsGuide.trailingAnchor)
        addButton.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, size: CGSize(width: 0.0, height: 40.0))
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        ingredientSummaryView.view.backgroundColor = UIColor.lightGray
        ingredientSummaryView.titleName = ingredient?.name
        
        view.layoutIfNeeded()
    }
    
    private func setupFoodLabels() {
        var previous: UILabel?
        let labelHeight: CGFloat = 30.0
        let padding: CGFloat = 8.0
        var accumulatedWidth: CGFloat = 0.0
        var accumulatedHeight: CGFloat = 0.0
        
        for (index, label) in foodLabels.enumerated() {
            let isSelected = index % 2 == 0 ? true: false // TODO: Add logic
            let foodLabel = createFoodLabel(with: label, isSelected: isSelected)
            foodLabelView.addSubview(foodLabel)
            
            foodLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
            foodLabel.widthAnchor.constraint(equalToConstant: foodLabel.intrinsicContentSize.width + 20.0).isActive = true
            accumulatedWidth += foodLabel.intrinsicContentSize.width + 20.0
            
            if let previous = previous {
                if accumulatedWidth > foodLabelView.bounds.width {
                    foodLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: padding).isActive = true
                    accumulatedWidth = 0.0
                    accumulatedHeight += labelHeight + padding
                } else {
                    foodLabel.topAnchor.constraint(equalTo: foodLabelView.topAnchor, constant: accumulatedHeight).isActive = true
                    foodLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: padding).isActive = true
                }
            }
            
            previous = foodLabel
        }
        
        foodLabelView.heightAnchor.constraint(equalToConstant: accumulatedHeight + labelHeight + padding).isActive = true
        
        view.layoutIfNeeded()
    }
    
    private func setupNutrientTable() {
        guard let ingredient = ingredient, let ndbno = ingredient.nbdId else { return }
        
        FoodClient.shared.fetchUsdaNutrients(for: ndbno) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let nutrients):
                    self.ingredient?.nutrients = nutrients
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                }
            }
        }
    }
    
    private func createFoodLabel(with title: String, isSelected: Bool) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.layer.cornerRadius = 30 / 2
        label.layer.masksToBounds = true
        label.backgroundColor = isSelected ? .green : UIColor.lightGray
        return label
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // Dismisses the view when user taps outside of the detail view.
//        guard let touch = touches.first, let tappedView = touch.view else { return }
//
//        if tappedView != containerView && !tappedView.isDescendant(of: containerView) {
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
}
