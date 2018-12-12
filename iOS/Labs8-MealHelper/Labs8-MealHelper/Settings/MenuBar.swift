//
//  SettingsCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 03/12/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

protocol MenuBarDelegate: class {
    func selectedMenuItemDidChange(to index: Int)
}

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    //MARK: - Properties
    
    let cellId = "MenuCell"
    let menuItems = ["Settings", "About"]
    weak var delegate: MenuBarDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: - Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupCollectionView()
        setupSelectedBookshelfBar()
    }
    
    var barViewLeftConstraint: NSLayoutConstraint?
    
    private func setupSelectedBookshelfBar() {
        let barView = UIView()
        barView.backgroundColor = .mountainBlue
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.layer.cornerRadius = 1.5
        barView.layer.masksToBounds = true
        addSubview(barView)
        
        barViewLeftConstraint = barView.leftAnchor.constraint(equalTo: leftAnchor)
        barViewLeftConstraint?.isActive = true
        barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        barView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }
    
    //MARK: - CollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedMenuItemDidChange(to: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        
        cell.menuLabel.text = menuItems[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
























