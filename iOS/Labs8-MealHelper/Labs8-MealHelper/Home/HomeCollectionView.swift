//
//  HomeCollectionView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 13/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol HomeCollectionViewDelegate: class {
    func didSelect(meal: Meal)
}

class HomeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    weak var actionDelegate: HomeCollectionViewDelegate?
    
    private let cellId = "mealCell"
    private let headerId = "headerView"
    
    var meals = [[Meal]]() {
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
        self.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealCell
        
        let meal = meals[indexPath.section][indexPath.item]
        cell.meal = meal
        cell.mealNameLabel.text = meal.mealTime
        cell.servingsLabel.text = "Servings: \(meal.servings ?? 1)"
        cell.experienceImageView.image = meal.experience == "0" ? #imageLiteral(resourceName: "thumb-up").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "thumb-down").withRenderingMode(.alwaysTemplate)
        cell.experienceImageView.tintColor = meal.experience == "0" ? .correctGreen : .incorrectRed
        
        switch meal.mealTime.lowercased() {
        case "breakfast": cell.mealTimeImageView.image = #imageLiteral(resourceName: "breakfast").withRenderingMode(.alwaysTemplate)
        case "lunch": cell.mealTimeImageView.image = #imageLiteral(resourceName: "lunchbag").withRenderingMode(.alwaysTemplate)
        case "dinner": cell.mealTimeImageView.image = #imageLiteral(resourceName: "dinner").withRenderingMode(.alwaysTemplate)
        case "snack": cell.mealTimeImageView.image = #imageLiteral(resourceName: "snacks").withRenderingMode(.alwaysTemplate)
        default: cell.mealTimeImageView.image = #imageLiteral(resourceName: "breakfast").withRenderingMode(.alwaysTemplate)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HomeSectionHeader
        
        let firstMealInSection = meals[indexPath.section].first
        header.titleLabel.text = firstMealInSection?.date
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 16, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.bounds.width - 16, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.section][indexPath.item]
        actionDelegate?.didSelect(meal: meal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
