//
//  FoodsCollectionViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 03.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol FoodCollectionViewDelegate: class {
    
}

class FoodsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    // MARK: - Public properties
    
    //weak var actionDelegate: HomeCollectionViewDelegate?
    
    var selectedFoodIds = [Int]() {
        didSet {
            if selectedFoodIds.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    
    var foods = [Recipe]()
    
    // MARK: - Private properties
    
    private let cellId = "FoodCell"
    
    lazy var noItemSelectedbarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionWhenNoItemsSelected))
    }()
    
    lazy var itemsSelectedBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(actionWhenItemsSelected))
    }()
    
    lazy var cancelBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissMealView))
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        FoodClient.shared.fetchRecipes { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let recipes):
                    self.foods = recipes
                    self.collectionView.reloadData()
                case .error(let error):
                    print(error)
                    // Handle error in UI
                    break
                }
            }
        }
    }
    
    // MARK: - CollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodCell
        
        let food = foods[indexPath.item]
        cell.mealNameLabel.text = food.name //meal.mealTime
//        cell.dateLabel.text = meal.date
//        cell.experienceLabel.text = meal.experience
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foods[indexPath.item]
        didSelect(food)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let food = foods[indexPath.item]
        didSelect(food)
    }
    
    private func didSelect(_ food: Recipe) {
        if selectedFoodIds.contains(food.identifier) {
            guard let index = selectedFoodIds.index(of: food.identifier) else { return }
            selectedFoodIds.remove(at: index)
        } else {
            selectedFoodIds.append(food.identifier)
        }
    }
    
    private func getSelectedFoods() -> [Recipe] {
        var selectedFoods = [Recipe]()
        for id in selectedFoodIds {
            if let food = foods.first(where: { $0.identifier == id }) {
                selectedFoods.append(food)
            }
        }
        return selectedFoods
    }
    
    // MARK: - User Actions
    
//    @objc func actionWhenNoItemsSelected() { }
//
    //@objc func actionWhenItemsSelected() { }
    
    @objc func actionWhenNoItemsSelected() {
        let ingredientsVC = SearchIngredientsTableViewController(navTitle: "Ingredients")
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    @objc func actionWhenItemsSelected() {
        let foods = getSelectedFoods()
        let date = Utils().dateString(for: Date())
        var temp = 0.0 // TODO: Change

        let weatherDispatchGroup = DispatchGroup()

        weatherDispatchGroup.enter()
        WeatherAPIClient().fetchWeather(for: 8038) { (weatherForecast) in
            
            temp = weatherForecast?.main.temp ?? 0
            weatherDispatchGroup.leave()
        }

        weatherDispatchGroup.notify(queue: .main) {
            let foodDispatchGroup = DispatchGroup()

            for food in foods {
                foodDispatchGroup.enter()
                let name = food.name

                FoodClient.shared.postMeal(name: name, mealTime: name, date: date, temp: temp) { (response) in
                    foodDispatchGroup.leave()
                }
            }

            foodDispatchGroup.notify(queue: .main) {
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
    
    @objc private func dismissMealView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    private func setupCollectionView() {
        collectionView.register(FoodCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        collectionView.layer.masksToBounds = true
        
        view.backgroundColor = .mountainDark
        title = "Recipes" //navTitle
        navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
}
