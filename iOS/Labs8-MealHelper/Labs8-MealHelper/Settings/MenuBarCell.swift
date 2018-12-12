//
//  SettingsCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 03/12/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class MenuBarCell: UICollectionViewCell
{
    //MARK: - UI Objects
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    //MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isHighlighted ? .white : .lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .white : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //MARK: - AutoLayout
    
    private func setupViews() {
        addSubview(menuLabel)
        menuLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: CGSize(width: 0, height: 28))
        menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
