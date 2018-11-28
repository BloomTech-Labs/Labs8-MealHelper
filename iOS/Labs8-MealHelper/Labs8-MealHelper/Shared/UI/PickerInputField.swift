//
//  PickerInputField.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class PickerInputField: UITextField {
    
    var icon: UIImage?
    
    var inputText: String? {
        didSet {
            self.text = inputText
        }
    }
    
    var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect = CGRect.zero, defaultValue: String, fontSize: CGFloat = 17.0, icon: UIImage? = nil) {
        self.init(frame: frame)
        self.text = defaultValue
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.icon = icon
        
        setupView()
        setupPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.setLeftPaddingPoints(10.0)
        self.setRightPaddingPoints(10.0)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupPicker() {
        self.inputView = picker
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        pickerToolBar.setItems([doneButton], animated: false)
        self.inputAccessoryView = pickerToolBar
        
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
}
