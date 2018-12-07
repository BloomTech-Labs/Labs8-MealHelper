//
//  HomeSectionHeader.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 07/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class HomeSectionHeader: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = Appearance.appFont(with: 14)
        label.text = "11/11/2011"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.masksToBounds = true
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
