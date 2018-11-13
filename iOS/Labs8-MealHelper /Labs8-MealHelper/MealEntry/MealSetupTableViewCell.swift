//
//  MealSetupTableViewCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealSetupTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    var meal: Any? {
        didSet {
            
        }
    }

    // MARK: - Private properties
    
    let servingSizeInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: "hi")
        inputField.picker.accessibilityIdentifier = "servingSize"
        return inputField
    }()
    
    let servingQtyInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: "hi")
        inputField.picker.accessibilityIdentifier = "servingQty"
        return inputField
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        // stackView.spacing = 30.0
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var servingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration

    private func setupViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(servingLabel)
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(servingSizeInputField)
        inputStackView.addArrangedSubview(servingQtyInputField)
        
        mainStackView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        
        nameLabel.text = "Gaggi"
        servingLabel.text = "1 cup"
        
        servingSizeInputField.picker.delegate = self
        servingSizeInputField.picker.dataSource = self
        servingQtyInputField.picker.delegate = self
        servingQtyInputField.picker.dataSource = self
    }
    
}

extension MealSetupTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "whatup"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            self.servingSizeInputField.text = "whatup"
        case "servingQty":
            self.servingQtyInputField.text = "whatup"
        default:
            break
        }
    }
    
}
