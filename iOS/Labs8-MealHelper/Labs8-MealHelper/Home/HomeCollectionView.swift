//
//  HomeCollectionView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 13/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class HomeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private let cellId = "mealCell"
    
    var meals = [Meal]() {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        register(MealCell.self, forCellWithReuseIdentifier: cellId)
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealCell
        
        let meal = meals[indexPath.item]
        cell.mealNameLabel.text = meal.mealTime
        cell.dateLabel.text = meal.date
        cell.experienceLabel.text = meal.experience
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 16, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
