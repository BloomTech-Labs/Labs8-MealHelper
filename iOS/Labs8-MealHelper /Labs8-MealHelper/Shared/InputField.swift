//
//  InputField.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 10.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

class InputField: UITextField {
    
    var icon: UIImage? // TODO: Add an icon to the text field
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect = CGRect.zero, placeholder: String, fontSize: CGFloat = 17.0, icon: UIImage? = nil) {
        self.init(frame: frame)
        self.placeholder = placeholder
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.icon = icon
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.setLeftPaddingPoints(10.0)
        self.setRightPaddingPoints(10.0)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
    
}
