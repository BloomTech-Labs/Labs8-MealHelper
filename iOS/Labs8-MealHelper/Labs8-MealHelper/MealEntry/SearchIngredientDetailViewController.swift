//
//  IngredientDetailViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol SearchIngredientDetailDelegate: class {
    func updateIngredient(_ ingredient: Ingredient, indexPath: IndexPath?)
}

class SearchIngredientDetailViewController: UIViewController {
    
    var ingredient: Ingredient? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SearchIngredientDetailDelegate?
    var delegateIndexPath: IndexPath?
    var backgroundIsTransparent = false
    
    let sidePadding: CGFloat = 20.0
    private let foodHelper = FoodHelper()
    private var transition = SearchIngredientAnimator()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus-icon")!, for: .normal)
        button.addTarget(self, action: #selector(addToRecipe), for: .touchUpInside)
        button.backgroundColor = .sunRed
        button.tintColor = .white
        button.layer.cornerRadius = buttonSize / 2
        return button
    }()
    
    let buttonSize: CGFloat = 55
    
    let headerView: FoodSummaryViewController = {
        let vc = FoodSummaryViewController()
        vc.view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        vc.view.layer.cornerRadius = 12
        vc.setupViews()
        return vc
    }()
    
    let macroNutrientsView: NutrientsView = {
        let view = NutrientsView()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    let nutrientTableView: NutrientDetailTableViewController = {
        let tv = NutrientDetailTableViewController()
        tv.tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tv.tableView.layer.cornerRadius = 12
        return tv
    }()
    
    private let foodLabelView: FoodLabelView = {
        let lv = FoodLabelView()
        return lv
    }()
    
    let ingredientsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tv.layer.cornerRadius = 12
        return tv
    }()
    
    let labelView: UIView = {
        let lv = UIView()
        lv.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        lv.layer.cornerRadius = 12
        return lv
    }()
    
    private let transparentBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        //view.alpha = 0.1
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mountain"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return frost
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNotifications()
        fetchNutrients()
    }
    
    override func viewDidLayoutSubviews() {
        //view.setGradientBackground(colorOne: UIColor.nightSkyBlue.cgColor, colorTwo: UIColor.mountainDark.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
    }
    
    // MARK: - User actions
    
    @objc private func didChangeServingType(note: Notification) {
        if let userInfo = note.userInfo,
            let servingType = userInfo["type"] as? FoodHelper.ServingTypes.RawValue,
            let servingQtyString = userInfo["quantity"] as? String,
            let servingQty = Double(servingQtyString),
            let nutrients = ingredient?.nutrients {
            
            ingredient?.nutrients = foodHelper.udpateNutrients(nutrients, to: servingType, amount: servingQty)
        }
    }
    
    @objc private func addToRecipe() {
        // When user taps on addToRecipe we notify the delegate VC that ingredient should be added to recipe
        dismiss(animated: true) {
            if let indexPath = self.delegateIndexPath, let ingredient = self.ingredient {
                self.delegate?.updateIngredient(ingredient, indexPath: indexPath)
            }
        }
    }
    
    @objc private func handleDismiss() {
        //        transitioningDelegate = self
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        if backgroundIsTransparent {
            view.addSubview(transparentBackgroundView)
            transparentBackgroundView.fillSuperview()
        } else {
            view.addSubview(backgroundImageView)
            backgroundImageView.fillSuperview()
            
            view.addSubview(blurEffect)
            blurEffect.fillSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: sidePadding), size: CGSize(width: 20, height: 20))
        
        view.addSubview(headerView.view)
        headerView.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 150))
        
        view.addSubview(labelView)
        labelView.anchor(top: headerView.view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 0, right: sidePadding))
        
        labelView.addSubview(foodLabelView)
        foodLabelView.anchor(top: labelView.safeAreaLayoutGuide.topAnchor, leading: labelView.safeAreaLayoutGuide.leadingAnchor, bottom: labelView.safeAreaLayoutGuide.bottomAnchor, trailing: labelView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 10.0, bottom: 0.0, right: 0.0))
        
        view.addSubview(macroNutrientsView)
        macroNutrientsView.anchor(top: labelView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 80))
        
        view.addSubview(nutrientTableView.tableView)
        nutrientTableView.tableView.anchor(top: macroNutrientsView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 200))
        
        view.addSubview(addButton)
        //        addButton.anchor(top: noteView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 16, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: buttonSize, height: buttonSize))
        addButton.frame = CGRect(x: view.center.x - (buttonSize / 2), y: view.center.y, width: buttonSize, height: buttonSize)
        addButton.center.y = UIScreen.main.bounds.height + buttonSize
        
        view.layoutIfNeeded()
        foodLabelView.setupFoodLabels()
    }
    
    private func updateViews() {
        headerView.titleName = ingredient?.name
        
        if let nutrients = ingredient?.nutrients {
            nutrientTableView.nutrients = nutrients
            macroNutrientsView.nutrients = nutrients
        }
    }
    
    private func setupNotifications() {
        // Listen for user changing serving types or qty
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeServingType), name: .MHFoodSummaryPickerDidChange, object: nil)
    }
    
    private func fetchNutrients() {
        guard let ingredient = ingredient, let ndbno = ingredient.nbdId else { return }
        
        FoodClient.shared.fetchUsdaNutrients(for: ndbno) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let nutrients):
                    let updatedNutrients = self.foodHelper.udpateNutrients(nutrients, to: "cup")
                    self.ingredient?.nutrients = updatedNutrients
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                }
            }
        }
    }
    
}
