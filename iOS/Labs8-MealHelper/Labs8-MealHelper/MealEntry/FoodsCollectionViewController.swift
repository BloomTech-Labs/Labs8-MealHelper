//
//  FoodsCollectionViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 03.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class FoodsCollectionViewController<T>: UICollectionViewController, UICollectionViewDelegateFlowLayout where T: Equatable {

    // MARK: - Public properties
    
    var selectedFoodAtIndex = [Int]() {
        didSet {
            if selectedFoodAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    var foods = [T]()
    var navTitle: String?
    var cellId = "FoodCell"
    
    // MARK: - Private properties
    
    
    lazy var noItemSelectedbarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didNotSelectItems))
    }()
    
    lazy var itemsSelectedBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didSelectItems))
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
    }
    
    // MARK: - CollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodCell<T>
        
        let food = foods[indexPath.item]
        cell.food = food
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 65)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foods[indexPath.item]
        didSelect(food)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let food = foods[indexPath.item]
        didSelect(food)
    }
    
    func didSelect(_ food: T) {
        guard let index = foods.index(of: food) else { return }
        
        if selectedFoodAtIndex.contains(index) {
            guard let index = selectedFoodAtIndex.index(of: index) else { return }
            selectedFoodAtIndex.remove(at: index)
        } else {
            selectedFoodAtIndex.append(index)
        }
    }
    
    func getSelectedFoods() -> [T] {
        var selectedFoods = [T]()
        for index in selectedFoodAtIndex {
            let food = foods[index]
            selectedFoods.append(food)
        }
        return selectedFoods
    }
    
    // MARK: - User Actions
    
    @objc func didNotSelectItems() { }

    @objc func didSelectItems() { }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    private func setupCollectionView() {
        collectionView.register(FoodCell<T>.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        collectionView.layer.masksToBounds = true
        
        view.backgroundColor = .mountainDark
        navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
    
        if let navTitle = navTitle {
            title = navTitle
        }
    }
    
}
