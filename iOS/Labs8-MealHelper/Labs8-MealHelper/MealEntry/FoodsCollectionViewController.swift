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
    
    var selectedFoodAtIndex = [Int]() {
        didSet {
            if selectedFoodAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    private let cellId = "FoodCell"
    
    var foods = [Recipe]() {
        didSet {
            collectionView.reloadData()
        }
    }
    // MARK: - Private properties
    
    lazy var noItemSelectedbarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionWhenNoItemsSelected))
    }()
    
    lazy var itemsSelectedBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(actionWhenItemsSelected))
    }()
    
    lazy var cancelBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissMealView))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(FoodCell.self, forCellWithReuseIdentifier: cellId)
        
        setupCollectionView()
        FoodClient.shared.fetchRecipes { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let recipes):
                    self.foods = recipes
                case .error(let error):
                    print(error)
                    // Handle error in UI
                    break
                }
            }
        }
    }
    
    // MARK: - Configuration
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        collectionView.layer.masksToBounds = true
        
        view.backgroundColor = .mountainDark
        self.title = "Recipes" //navTitle
        //navigationController?.isNavigationBarHidden = false
        navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
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
        
        if selectedFoodAtIndex.contains(food.identifier) {
            guard let index = selectedFoodAtIndex.index(of: food.identifier) else { return }
            selectedFoodAtIndex.remove(at: index)
        } else {
            selectedFoodAtIndex.append(food.identifier)
        }
    }
    
//    func selectFood(at indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? FoodTableViewCell<Resource> {
//            cell.updateLayouts()
//        }
//
//        if selectedFoodAtIndex.contains(indexPath.row) {
//            guard let index = selectedFoodAtIndex.index(of: indexPath.row) else { return }
//            selectedFoodAtIndex.remove(at: index)
//        } else {
//            selectedFoodAtIndex.append(indexPath.row)
//        }
//    }
//
//    func selectFood(from cell: UITableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        selectFood(at: indexPath)
//    }
    
    func getSelectedFoods() -> [Recipe] {
        var selectedFoods = [Recipe]()
        for index in selectedFoodAtIndex {
            let food = foods[index]
            selectedFoods.append(food)
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
        //let foods = getSelectedFoods()
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

            for food in self.foods {
                foodDispatchGroup.enter()
                let name = food.name ?? ""

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
}
